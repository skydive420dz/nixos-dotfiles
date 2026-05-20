# Keyboard

## Files

- [NixOS input](../../system/modules/input.nix)
- [Hyprland input](../../config/hypr/hyprland.lua)
- [macOS defaults](../../../nixos-macos/darwin/modules/defaults.nix)

## Current Feel

- macOS reference:
  - `InitialKeyRepeat = 14`
  - `KeyRepeat = 1`
- Hyprland match:
  - `repeat_delay = 210`
  - `repeat_rate = 67`

## Notes

- Caps is handled through Kanata on NixOS.
- keyd is disabled. Keep it disabled while Kanata owns keyboards.
- Keep app-native navigation simple until a real layer system is worth the setup cost.

## NixOS Kanata Investigation

Goal: keep the MSI Bravo 15 C7V keyboard behavior documented while Kanata
replaces keyd.

Laptop keyboard spec from MSI: blue keyboard with anti-ghost key, 99-key layout.
Anti-ghosting helps with simultaneous key presses, but Linux/Kanata still only
can remap keys that emit visible input events.

## Hardware-Specific Decisions

These are intentional machine-specific choices. Keep them documented so they can
move into host-level Nix options later instead of becoming mystery strings.

| Area | Scope | Where | Decision | Why | Future cleanup |
| --- | --- | --- | --- | --- | --- |
| Touchpad toggle | MSI Bravo 15 C7V | `config/hypr/hyprland.lua` | Bind `code:202` to an inline Lua toggle | MSI emits `XF86TouchpadToggle`, but Hypr did not catch the keysym bind; keycode binding worked | Move keycode/device into host options |
| Touchpad device | MSI Bravo 15 C7V | `config/hypr/hyprland.lua` | Hardcode `pnp0c50:0b-06cb:7e7e-touchpad` | Hypr runtime toggle needs the exact device name from `hyprctl devices` | Move to `mkOption` per host |
| Play/pause media key | NixOS shell | `config/hypr/hyprland.lua`, `config/quickshell/root/Bar.qml` | Bind `XF86AudioPlay` to Quickshell IPC | Quickshell already owns MPRIS state/control, so no extra media package is needed | Keep as-is unless media ownership changes |
| Extra `\|` key | MSI Bravo 15 C7V 99-key layout | `system/modules/input.nix` | Map Kanata `IntlBackslash = bksl` | Built-in 99-key layout emitted the wrong logical key for the physical `\|` key | Keep with host keyboard options later |
| DrunkDeer A75 Pro ANSI | External USB keyboard | `system/modules/input.nix` | Separate `kanata-drunkdeer.service` on `/dev/input/by-id/usb-Drunkdeer_Drunkdeer_A75_Pro_ANSI_RYMicro-event-kbd` | External keyboard should get the same Caps tap/hold and Caps+Y/P clipboard layer without coupling to the laptop keyboard service | Move keyboard device paths into host options later |
| DrunkDeer control | External keyboard configuration | `pkgs/drunkdeerctl`, `system/modules/input.nix` | Start with a read-only Linux-native HID probe | Chromium-family portal access was fragile; `DrunkDeer-Control` documents the HID protocol well enough to build our own path | Add profile writes only after list/info are boring |
| Display-mode key | MSI Bravo 15 C7V | none | Leave `Fn+F11` unmapped | It emits `Super+p`, not a clean display XF86 key; no current workflow needs it | Design explicit monitor profile/picker later |

## Future Kanata Layer Ideas

Do not rush these. The current Kanata config is intentionally small and stable.
Only add layer behavior when it removes real friction and does not fight app-native
bindings.

| Idea | Candidate behavior | Notes |
| --- | --- | --- |
| Vim-style navigation | Layer + `h/j/k/l` sends arrows | Useful outside terminal/editor contexts |
| Word motion | Layer + `w/b/e` sends word-forward/back behavior | Needs app-safe modifier choices per platform |
| Copy/paste holds | Hold `y` for copy, hold `p` for paste | Candidate replacement for explicit layer `Y/P`; test carefully to avoid typing latency |
| Workspace/tag switching | Hold number keys to switch workspaces/tags | Mirrors the Hypr workspace mental model |
| Move to workspace/tag | Shift + hold number keys to move window to workspace/tag | Should map to Hypr actions, not app-level number input |

Useful commands after installing the diagnostic tools:

```sh
sudo evtest
sudo libinput debug-events --show-keycodes
wev
drunkdeerctl list
drunkdeerctl --list
drunkdeerctl status
drunkdeerctl info --raw
```

## DrunkDeer Control Plan

Use `DrunkDeer-Control` as a protocol reference, not as an app to package. The
first local tool is `drunkdeerctl`, a read-only probe that:

- scans `/sys/class/hidraw` for DrunkDeer VID `0x352d`
- sends the identity packet over hidraw with report ID `0x04`
- tries all matching hidraw interfaces and prefers the richer config descriptor
- decodes model/type bytes and current global mode bytes
- reports firmware using the app-observed bytes `[8], [7]`; A75 Pro currently
  reports `0.09` / `0x0009`
- does not write profile, actuation, remap, Last Win, or Rapid Trigger settings

Current A75 Pro observations:

| Path | Value |
| --- | --- |
| Main event path | `/dev/input/by-id/usb-Drunkdeer_Drunkdeer_A75_Pro_ANSI_RYMicro-event-kbd` |
| Config hidraw paths | `/dev/hidraw1`, `/dev/hidraw2` |
| Config interface note | The keyboard can expose multiple hidraw nodes; probe all, because the keyboard interface may time out while the vendor/config interface responds |
| VID/PID | `352d:2383` |
| HID name | `Drunkdeer Drunkdeer A75 Pro ANSI` |
| A75 Pro identity bytes | `(11, 4, 3)` |
| Firmware bytes | raw `[7]=0x09`, `[8]=0x00`; display `0.09` |

Before adding writes, verify:

1. `drunkdeerctl list` finds the keyboard as the regular user.
2. `drunkdeerctl status` returns model `A75 Pro`.
3. `drunkdeerctl info --raw` returns raw bytes for protocol notes.
4. udev assigns DrunkDeer hidraw nodes to group `input` after `nrs` and
   reconnect/reload.

Known input devices from `/proc/bus/input/devices`:

| Device | Event | Notes |
| --- | --- | --- |
| AT Translated Set 2 keyboard | event0 | Built-in keyboard |
| Video Bus | event1, event2 | Brightness/display-style hotkeys may appear here |
| MSI WMI hotkeys | event3 | Vendor hotkeys |
| Kanata virtual keyboard | service output | Current Kanata output device |
| DrunkDeer A75 Pro ANSI | event22 | External keyboard main event device; stable path is `/dev/input/by-id/usb-Drunkdeer_Drunkdeer_A75_Pro_ANSI_RYMicro-event-kbd` |

Inventory table:

| Physical key | Raw device | Raw code/name | Kanata output | Wayland/wev output | Desired behavior |
| --- | --- | --- | --- | --- | --- |
| Caps |  |  |  |  | tap Esc / hold Ctrl+Alt |
| Fn+F1 |  |  |  |  |  |
| Fn+F2 |  |  |  |  |  |
| Fn+F3 |  |  |  |  |  |
| Fn+F4 |  |  |  |  |  |
| Fn+F5 |  |  |  |  |  |
| Fn+F6 |  |  |  |  |  |
| Fn+F7 |  |  |  |  |  |
| Fn+F8 |  |  |  |  |  |
| Fn+F9 |  |  |  |  |  |
| Fn+F10 |  |  |  |  |  |
| Fn+F11 |  |  |  |  |  |
| Fn+F12 |  |  |  |  |  |
| MSI/custom key |  |  |  |  |  |
| Extra key between Right Ctrl and AltGr | internal keyboard | `IntlBackslash` | `bksl`; expected `\|` |  | fixed via Kanata `IntlBackslash = bksl` |

Observed terminal escape output during first pass:

| Physical key | Terminal output | Notes |
| --- | --- | --- |
| F1-F12 plain | `^[OP` through `^[[24~` | Terminal sees literal F1-F12 |
| PrintScreen row key | `^[[57361u` | Kitty/terminal extended key encoding |
| Media play key | `^[[57428u` | Kitty encodes this as `MEDIA_PLAY`; wired to existing Quickshell MPRIS IPC |
| Fn+F4 touchpad toggle | `XF86TouchpadToggle` plus noisy modifiers | Wired to native Hyprland per-device toggle |
| Fn+F11 display mode | `Super+p` | Parked until we want an explicit monitor-mode workflow |
