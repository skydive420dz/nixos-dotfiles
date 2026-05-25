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
disk_pct="$(df -P / | awk 'NR==2 {gsub("%", "", $5); print $5}')"
read _ u1 n1 s1 i1 w1 q1 r1 t1 _ < /proc/stat
total1=$((u1+n1+s1+i1+w1+q1+r1+t1))
idle1=$((i1+w1))
sleep 1
read _ u2 n2 s2 i2 w2 q2 r2 t2 _ < /proc/stat
total2=$((u2+n2+s2+i2+w2+q2+r2+t2))
idle2=$((i2+w2))
totald=$((total2-total1))
idled=$((idle2-idle1))
cpu_pct=0
if [ "$totald" -gt 0 ]; then
  cpu_pct=$((100*(totald-idled)/totald))
fi
ram_pct="$(awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {if (t > 0) printf "%d", 100*(t-a)/t; else print 0}' /proc/meminfo)"
b=""
bpct=""
for f in /sys/class/power_supply/BAT*/capacity; do
  if [ -r "$f" ]; then
    s="$(cat "${f%/capacity}/status" 2>/dev/null || true)"
    c="$(cat "$f" 2>/dev/null || true)"
    b="$s $c%"
    bpct="$c"
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
gpu_temp=""
gpu_util=""
if command -v nvidia-smi >/dev/null 2>&1; then
  gpu="$(nvidia-smi --query-gpu=temperature.gpu,power.draw,utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null | awk -F', ' 'NR==1 {print $1 "C, " $2 "W, " $3 "%, " $4 "/" $5 "MiB"}')"
  gpu_temp="$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | awk 'NR==1 {print $1}')"
  gpu_util="$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | awk 'NR==1 {print $1}')"
fi
top_proc="$(ps -eo comm,pcpu,pmem --sort=-pcpu 2>/dev/null | awk 'NR==2 {print $1 " " $2 "% cpu, " $3 "% ram"}')"
failed_units="$(systemctl --failed --no-legend 2>/dev/null | wc -l | awk '{print $1}')"
kernel="$(uname -r 2>/dev/null || true)"
secureboot="$(bootctl status 2>/dev/null | awk -F': ' '/Secure Boot/ {print $2; exit}')"
printf '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n' "$u" "$l" "$b" "$disk" "$svc" "$gpu" "$cpu_pct" "$ram_pct" "$disk_pct" "$bpct" "$gpu_temp" "$gpu_util" "$top_proc" "$failed_units" "$kernel" "$secureboot"
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
                "cpu_pct": "0",
                "ram_pct": "0",
                "disk_pct": "0",
                "battery_pct": "",
                "gpu_temp": "",
                "gpu_util": "",
                "top_proc": "--",
                "failed_units": "--",
                "kernel": "--",
                "secureboot": "--",
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
            "cpu_pct": "0",
            "ram_pct": "0",
            "disk_pct": "0",
            "battery_pct": "",
            "gpu_temp": "",
            "gpu_util": "",
            "top_proc": "--",
            "failed_units": "--",
            "kernel": "--",
            "secureboot": "--",
            "ollama": "--",
        }

    lines = out.splitlines()
    battery = lines[2] if len(lines) > 2 else ""
    disk = lines[3] if len(lines) > 3 else ""
    services = lines[4] if len(lines) > 4 else ""
    gpu = lines[5] if len(lines) > 5 else ""
    cpu_pct = lines[6] if len(lines) > 6 else ""
    ram_pct = lines[7] if len(lines) > 7 else ""
    disk_pct = lines[8] if len(lines) > 8 else ""
    battery_pct = lines[9] if len(lines) > 9 else ""
    gpu_temp = lines[10] if len(lines) > 10 else ""
    gpu_util = lines[11] if len(lines) > 11 else ""
    top_proc = lines[12] if len(lines) > 12 else ""
    failed_units = lines[13] if len(lines) > 13 else ""
    kernel = lines[14] if len(lines) > 14 else ""
    secureboot = lines[15] if len(lines) > 15 else ""
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
        "cpu_pct": cpu_pct or "0",
        "ram_pct": ram_pct or "0",
        "disk_pct": disk_pct or "0",
        "battery_pct": battery_pct or "",
        "gpu_temp": gpu_temp or "",
        "gpu_util": gpu_util or "",
        "top_proc": top_proc or "--",
        "failed_units": failed_units or "0",
        "kernel": kernel or "--",
        "secureboot": secureboot or "--",
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


def router():
    reachable = bool(run(["ping", "-c", "1", "-W", "1", "192.168.1.1"], timeout=2))
    http = run(["nc", "-vz", "-w", "2", "192.168.1.1", "80"], timeout=3, keep_stderr=True)
    return {
        "online": reachable,
        "http": bool(http),
        "ip": "192.168.1.1",
        "label": "DD-WRT",
    }


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
        "router": router(),
    }
    tmp = STATUS_PATH + ".tmp"
    with open(tmp, "w") as f:
        json.dump(data, f, indent=2)
    os.replace(tmp, STATUS_PATH)


if __name__ == "__main__":
    while True:
        snapshot()
        time.sleep(10)
