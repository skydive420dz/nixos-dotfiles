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
- keyd is disabled. Keep it disabled while Kanata owns the internal keyboard.
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
```

Known input devices from `/proc/bus/input/devices`:

| Device | Event | Notes |
| --- | --- | --- |
| AT Translated Set 2 keyboard | event0 | Built-in keyboard |
| Video Bus | event1, event2 | Brightness/display-style hotkeys may appear here |
| MSI WMI hotkeys | event3 | Vendor hotkeys |
| Kanata virtual keyboard | service output | Current Kanata output device |

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
