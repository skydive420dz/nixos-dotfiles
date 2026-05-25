#!/usr/bin/env python3
import json
import os
import shlex
import subprocess
import time

ROOT = os.path.dirname(os.path.abspath(__file__))
STATE_DIR = os.environ.get("HOME_DECK_STATE_DIR", ROOT)
STATUS_PATH = os.path.join(STATE_DIR, "status.json")
OLLAMA_TAGS_URL = os.environ.get("HOME_DECK_OLLAMA_TAGS_URL", "http://127.0.0.1:11434/api/tags")

HOSTS = {
    "msi": {
        "local": True,
        "ip": "192.168.1.175",
        "extra": "secure boot: enabled",
        "services": ["ollama", "sshd"],
    },
    "t430": {
        "ssh": "t430",
        "ip": "192.168.1.88",
        "extra": "battery",
        "services": ["sshd", "seatd", "tlp"],
    },
    "x230t": {
        "ssh": "x230t",
        "ip": "192.168.1.164",
        "extra": "battery",
        "services": ["sshd", "seatd", "tlp", "kanata-x230t"],
    },
}

REMOTE_SCRIPT = r'''
u="$(uptime | sed 's/.* up *//; s/, *[0-9][0-9]* user.*//; s/, *load average.*//')"
l="$(uptime | sed 's/.*load average[s]*: *//')"
disk="$(df -h / | awk 'NR==2 {print $5 " used, " $4 " free"}')"
b=""
for f in /sys/class/power_supply/BAT*/capacity; do
  if [ -r "$f" ]; then
    s="$(cat "${f%/capacity}/status" 2>/dev/null || true)"
    c="$(cat "$f" 2>/dev/null || true)"
    b="$s $c%"
    break
  fi
done
svc=""
for name in "$@"; do
  state="$(systemctl is-active "$name" 2>/dev/null || true)"
  [ -n "$svc" ] && svc="$svc, "
  svc="$svc$name:${state:-missing}"
done
gpu=""
if command -v nvidia-smi >/dev/null 2>&1; then
  gpu="$(nvidia-smi --query-gpu=temperature.gpu,power.draw,utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null | awk -F', ' 'NR==1 {print $1 "C, " $2 "W, " $3 "%, " $4 "/" $5 "MiB"}')"
fi
printf '%s\n%s\n%s\n%s\n%s\n%s\n' "$u" "$l" "$b" "$disk" "$svc" "$gpu"
'''


def run(command, timeout=5, keep_stderr=False):
    try:
        return subprocess.check_output(
            command,
            stderr=subprocess.STDOUT if keep_stderr else subprocess.DEVNULL,
            timeout=timeout,
            text=True,
        ).strip()
    except Exception:
        return ""


def probe(host):
    if host.get("local"):
        return run(
            [
                "sh",
                "-lc",
                REMOTE_SCRIPT + "\n",
                "sh",
            ]
            + host.get("services", []),
            timeout=5,
        )

    return run(
        [
            "ssh",
            "-o",
            "BatchMode=yes",
            "-o",
            "ConnectTimeout=3",
            host["ssh"],
            "sh -lc " + shlex.quote(REMOTE_SCRIPT) + " sh "
            + " ".join(shlex.quote(s) for s in host.get("services", [])),
        ],
        timeout=8,
    )


def remote(host):
    pinged = bool(run(["ping", "-c", "1", "-W", "1", host["ip"]], timeout=2))
    out = probe(host)
    if not out:
        if pinged:
            return {
                "online": True,
                "uptime": "awake",
                "load": "ssh unavailable",
                "extra": host["ip"],
                "battery": "--",
                "disk": "--",
                "services": "ssh unavailable",
                "gpu": "--",
                "ollama": "--",
            }
        return {
            "online": False,
            "uptime": "--",
            "load": "--",
            "extra": "not reachable",
            "battery": "--",
            "disk": "--",
            "services": "--",
            "gpu": "--",
            "ollama": "--",
        }

    lines = out.splitlines()
    battery = lines[2] if len(lines) > 2 else ""
    disk = lines[3] if len(lines) > 3 else ""
    services = lines[4] if len(lines) > 4 else ""
    gpu = lines[5] if len(lines) > 5 else ""
    extra = host["extra"]
    if extra == "battery":
        extra = "battery: " + (battery or "--")

    return {
        "online": True,
        "uptime": lines[0] if len(lines) > 0 else "--",
        "load": lines[1] if len(lines) > 1 else "--",
        "extra": extra,
        "battery": battery or "--",
        "disk": disk or "--",
        "services": services or "--",
        "gpu": gpu or "--",
        "ollama": "--",
    }


def ipad():
    reachable = run(["ping", "-c", "1", "-W", "1", "192.168.1.185"], timeout=2)
    ssh = run(
        [
            "nc",
            "-vz",
            "-w",
            "2",
            "192.168.1.185",
            "22",
        ],
        timeout=3,
        keep_stderr=True,
    )
    online = bool(reachable)
    return {
        "online": online,
        "uptime": "jailbreak: " + ("ssh ready" if ssh else "unknown"),
        "load": "ip: 192.168.1.185",
        "extra": "ios 9.3.5",
    }


def ollama():
    out = run(["curl", "-fsS", OLLAMA_TAGS_URL], timeout=3)
    if not out:
        return "not reachable"
    try:
        data = json.loads(out)
        names = []
        for model in data.get("models", []):
            name = model.get("name")
            if name:
                names.append(name)
        return ", ".join(names[:3]) if names else "ready"
    except Exception:
        return "ready"


def snapshot():
    os.makedirs(STATE_DIR, exist_ok=True)
    msi = remote(HOSTS["msi"])
    msi["ollama"] = ollama()
    data = {
        "updated": time.strftime("%I:%M:%S %p").lstrip("0"),
        "msi": msi,
        "t430": remote(HOSTS["t430"]),
        "x230t": remote(HOSTS["x230t"]),
        "ipad": ipad(),
    }
    tmp = STATUS_PATH + ".tmp"
    with open(tmp, "w") as f:
        json.dump(data, f, indent=2)
    os.replace(tmp, STATUS_PATH)


if __name__ == "__main__":
    while True:
        snapshot()
        time.sleep(10)
