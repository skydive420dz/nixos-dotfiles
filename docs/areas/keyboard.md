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

- Caps is handled through keyd on NixOS.
- Keep app-native navigation simple until a real layer system is worth the setup cost.
