#!/usr/bin/env python3
import argparse
import os
import select
import sys
import time
from pathlib import Path


DRUNKDEER_VID = 0x352D
REPORT_ID = 0x04
PACKET_SIZE = 63
IDENTITY_PACKET = bytes([0xA0, 0x02]) + bytes(PACKET_SIZE - 2)

KNOWN_PIDS = {
    0x2382,
    0x2383,
    0x2384,
    0x2386,
    0x2387,
    0x238F,
    0x2390,
    0x2391,
    0x2394,
    0x23B3,
    0x23B4,
    0x23B5,
    0x23B6,
    0x2A08,
}

MODEL_BY_TYPE_BYTES = {
    (11, 3, 1): ("G60", 60),
    (11, 2, 1): ("G65", 65),
    (15, 1, 1): ("G65", 65),
    (11, 1, 1): ("A75", 75),
    (11, 4, 1): ("A75", 75),
    (11, 3, 3): ("G60 m1", 600),
    (11, 19, 1): ("G60 m2", 601),
    (11, 21, 1): ("G60 m3", 602),
    (11, 6, 5): ("X60", 603),
    (11, 2, 5): ("G65 Lite", 650),
    (11, 2, 3): ("G65 m1", 651),
    (11, 16, 1): ("G65 m2", 652),
    (11, 18, 1): ("G65 m3", 653),
    (11, 4, 3): ("A75 Pro", 750),
    (11, 4, 2): ("A75 ISO", 751),
    (11, 4, 5): ("G75", 754),
    (11, 4, 7): ("G75 JP", 755),
    (11, 4, 4): ("A75 Ultra", 756),
    (11, 5, 4): ("A75 Master", 757),
}


class DrunkDeerError(Exception):
    pass


def parse_uevent(path):
    data = {}
    with open(path, "r", encoding="utf-8") as handle:
        for line in handle:
            key, _, value = line.strip().partition("=")
            if key:
                data[key] = value
    return data


def parse_hid_id(value):
    try:
        _bus, vid, pid = value.split(":")
        return int(vid, 16), int(pid, 16)
    except ValueError:
        return None, None


def report_descriptor_size(hidraw):
    descriptor = hidraw / "device" / "report_descriptor"
    try:
        return len(descriptor.read_bytes())
    except OSError:
        return 0


def hidraw_devices(include_unknown=False):
    devices = []
    for hidraw in sorted(Path("/sys/class/hidraw").glob("hidraw*")):
        uevent = hidraw / "device" / "uevent"
        if not uevent.exists():
            continue
        data = parse_uevent(uevent)
        vid, pid = parse_hid_id(data.get("HID_ID", ""))
        if vid != DRUNKDEER_VID:
            continue
        if not include_unknown and pid not in KNOWN_PIDS:
            continue
        name = data.get("HID_NAME", "")
        phys = data.get("HID_PHYS", "")
        uniq = data.get("HID_UNIQ", "")
        devices.append(
            {
                "node": f"/dev/{hidraw.name}",
                "sysfs": str(hidraw),
                "vid": vid,
                "pid": pid,
                "name": name,
                "phys": phys,
                "uniq": uniq,
                "report_descriptor_size": report_descriptor_size(hidraw),
            }
        )
    return devices


def normalize_report(raw):
    if not raw:
        return b""
    if raw[0] == REPORT_ID and len(raw) >= 64:
        return raw[1:64]
    return raw[:PACKET_SIZE]


def write_identity(node):
    try:
        fd = os.open(node, os.O_RDWR | os.O_NONBLOCK)
    except PermissionError as exc:
        raise DrunkDeerError(
            f"permission denied opening {node}; rebuild/apply udev rules or try sudo once"
        ) from exc
    except OSError as exc:
        raise DrunkDeerError(f"failed to open {node}: {exc}") from exc

    try:
        os.write(fd, bytes([REPORT_ID]) + IDENTITY_PACKET)
        deadline = time.monotonic() + 2.5
        while time.monotonic() < deadline:
            timeout = max(0.0, deadline - time.monotonic())
            readable, _, _ = select.select([fd], [], [], timeout)
            if not readable:
                continue
            raw = os.read(fd, 64)
            payload = normalize_report(raw)
            if len(payload) >= 3 and payload[0:3] == b"\xA0\x02\x00":
                return payload
        raise DrunkDeerError(f"timed out waiting for identity response from {node}")
    finally:
        os.close(fd)


def decode_identity(payload):
    if len(payload) < 37:
        raise DrunkDeerError(f"identity response too short: {len(payload)} bytes")
    type_bytes = tuple(payload[4:7])
    model_name, type_code = MODEL_BY_TYPE_BYTES.get(type_bytes, ("unknown", None))
    firmware_triplet = tuple(payload[34:37])
    return {
        "raw": payload,
        "type_bytes": type_bytes,
        "model_name": model_name,
        "type_code": type_code,
        "turbo": payload[15],
        "rapid_trigger": payload[16],
        "rtp": payload[18],
        "last_win": payload[19],
        "profile_index": payload[20],
        "rgb_mode": payload[22],
        "rgb_speed": payload[23],
        "rgb_brightness": payload[24],
        "rt_match": payload[30],
        "auto_match_mode": payload[31],
        "last_win_replace": payload[32],
        "firmware": ".".join(str(v) for v in firmware_triplet),
    }


def print_devices(devices):
    if not devices:
        print("No DrunkDeer hidraw devices found.")
        return
    print(f"{'NODE':<14} {'VID:PID':<13} {'REPORT':<7} {'PHYS':<26} NAME")
    for device in devices:
        print(
            f"{device['node']:<14} "
            f"{device['vid']:04x}:{device['pid']:04x}   "
            f"{device['report_descriptor_size']:<7} "
            f"{device['phys']:<26} "
            f"{device['name']}"
        )


def cmd_list(args):
    print_devices(hidraw_devices(include_unknown=args.all))


def candidate_devices(node=None):
    if node:
        return [{"node": node}]
    devices = hidraw_devices()
    if not devices:
        raise DrunkDeerError("No DrunkDeer hidraw devices found.")

    # DrunkDeer boards expose multiple HID interfaces. The keyboard interface
    # often times out for vendor reports; prefer the richer config descriptor,
    # then keep probing the remaining candidates before giving up.
    return sorted(
        devices,
        key=lambda device: (
            device["report_descriptor_size"],
            device["phys"].endswith("/input1"),
        ),
        reverse=True,
    )


def cmd_info(args):
    errors = []
    for device in candidate_devices(args.device):
        try:
            payload = write_identity(device["node"])
            break
        except DrunkDeerError as exc:
            errors.append(f"{device['node']}: {exc}")
    else:
        raise DrunkDeerError(
            "no identity response from any DrunkDeer hidraw device:\n  "
            + "\n  ".join(errors)
        )

    info = decode_identity(payload)
    if "vid" in device:
        print(f"device: {device['node']} ({device['vid']:04x}:{device['pid']:04x})")
        print(f"name: {device['name']}")
        print(f"phys: {device['phys']}")
    else:
        print(f"device: {device['node']}")
    print(f"model: {info['model_name']} ({info['type_code'] or 'unknown'})")
    print(f"type-bytes: {info['type_bytes']}")
    print(f"firmware: {info['firmware']}")
    print(f"turbo: {info['turbo']}")
    print(f"rapid-trigger: {info['rapid_trigger']}")
    print(f"rtp: {info['rtp']}")
    print(f"last-win: {info['last_win']}")
    print(f"profile-index: {info['profile_index']}")
    print(f"rt-match: {info['rt_match']}")
    print(f"auto-match-mode: {info['auto_match_mode']}")
    print(f"last-win-replace: {info['last_win_replace']}")
    if args.raw:
        print("raw:", " ".join(f"{byte:02x}" for byte in info["raw"]))


def build_parser():
    parser = argparse.ArgumentParser(
        prog="drunkdeerctl",
        description="Read-only DrunkDeer keyboard HID probe.",
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    list_parser = subparsers.add_parser("list", help="list DrunkDeer hidraw devices")
    list_parser.add_argument("--all", action="store_true", help="include unknown DrunkDeer PIDs")
    list_parser.set_defaults(func=cmd_list)

    info_parser = subparsers.add_parser("info", help="read keyboard identity/spec response")
    info_parser.add_argument("-d", "--device", help="hidraw node, e.g. /dev/hidraw1")
    info_parser.add_argument("--raw", action="store_true", help="print raw identity payload")
    info_parser.set_defaults(func=cmd_info)

    return parser


def main():
    argv = sys.argv[1:]
    if argv and argv[0] == "--list":
        argv = ["list"] + argv[1:]
    parser = build_parser()
    args = parser.parse_args(argv)
    try:
        args.func(args)
    except DrunkDeerError as exc:
        print(f"drunkdeerctl: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
