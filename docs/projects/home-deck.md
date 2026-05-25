# Home Deck

Home Deck is the tiny iPad mini dashboard served from MSI.

The iPad is only the display. MSI owns the service, status collection, and
Ollama proxy.

## Current Network Map

| Device | Address | Notes |
| --- | --- | --- |
| MSI | `192.168.1.175` | NixOS, Secure Boot, Ollama, Home Deck host |
| T430 | `192.168.1.88` | CachyOS, `dwl`, `seatd`, `tlp` |
| X230T Wi-Fi | `192.168.1.164` | CachyOS tablet, `kanata-x230t` |
| X230T LAN | `192.168.1.165` | Reserved fallback |
| iPad mini | `192.168.1.185` | iOS 9.3.5, Phoenix jailbreak, SSH |
| MacBook | `192.168.1.201` | Temporary development host |

## DD-WRT Static Leases

DD-WRT's static lease table was unreliable, so the stable entries live in
**Services -> Services -> DNSMasq -> Additional DNSMasq Options**.

```text
dhcp-host=00:41:0e:2b:fd:73,msi-wifi,192.168.1.175,infinite
dhcp-host=04:7c:16:ab:04:f2,msi-lan,192.168.1.176,infinite
dhcp-host=6c:88:14:fe:92:94,t430-wifi,192.168.1.88,infinite
dhcp-host=28:d2:44:1b:7e:a2,t430-lan,192.168.1.89,infinite
dhcp-host=e0:9d:31:2d:ee:5c,x230t-wifi,192.168.1.164,infinite
dhcp-host=3c:97:0e:ec:4a:9e,x230t-lan,192.168.1.165,infinite
dhcp-host=8c:7c:92:39:a5:79,ipad,192.168.1.185,infinite
dhcp-host=b2:e4:14:e5:9c:59,macbook,192.168.1.201,infinite
```

After editing, use **Save** then **Apply Settings**. Rebooting DD-WRT may be
needed if a lease refuses to settle.

## iPad State

The iPad is an iPad mini 1:

- Model: `MD529LL/A`
- iOS: `9.3.5`
- MAC: `8c:7c:92:39:a5:79`
- IP: `192.168.1.185`

Phoenix is semi-untethered. Packages and passwords persist, but if the iPad
reboots, open Phoenix on the iPad and run the jailbreak again before expecting
SSH to work.

SSH needs an old RSA host key allowance:

```sshconfig
Host ipad-mini
  HostName 192.168.1.185
  User root
  HostKeyAlgorithms +ssh-rsa
  PubkeyAcceptedAlgorithms +ssh-rsa
```

## NixOS Service

The dashboard files live in:

```text
services/home-deck/
```

The NixOS module is:

```text
system/modules/services/home-deck.nix
```

It creates two services:

```text
home-deck.service
home-deck-status.service
```

`home-deck.service` serves the web UI on:

```text
http://192.168.1.175:8088/
```

`home-deck-status.service` writes:

```text
/var/lib/home-deck/status.json
```

The web server exposes that file at:

```text
http://192.168.1.175:8088/status.json
```

## What It Shows

The current deck displays:

- Clock/date
- MSI, T430, X230T, and iPad online state
- Uptime/load
- CPU and RAM meters
- Laptop batteries
- Root filesystem usage
- Alert colors for low battery, high disk, hot GPU, offline hosts, and service issues
- Important service status
- MSI GPU temperature, watts, utilization, and VRAM
- Ollama model availability
- Router reachability and HTTP status
- A small event timeline
- A night mode toggle for dim display use
- Lab notes for the current network and jailbreak state
- An `Ask MSI` prompt box proxied to Ollama, with model selection and prompt presets

## Operating Notes

After applying the NixOS config:

```sh
sudo systemctl status home-deck.service
sudo systemctl status home-deck-status.service
curl http://127.0.0.1:8088/status.json
```

From another device:

```sh
curl http://192.168.1.175:8088/status.json
```

On the iPad, open:

```text
http://192.168.1.175:8088/
```

Then use Safari's **Add to Home Screen** to run it as a near-fullscreen iOS web
app. If the icon was created before the Apple web-app tags existed, delete and
recreate it.

## Next Ideas

- Router/DD-WRT panel
- Local lab notes panel
- Safer command buttons, like refresh status or ping all hosts
- Theme modes for night clock and compact terminal views
