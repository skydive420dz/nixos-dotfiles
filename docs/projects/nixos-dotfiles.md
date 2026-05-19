# NixOS Dotfiles

## Current

- Hyprland config is Lua-only.
- Quickshell owns bar, launcher, clipboard, OSD, and popovers.
- Keep git clean between jobs.

## Commands

- `nrs`
- `hyr reload`
- `systemctl --user restart quickshell`
- `git status --short --branch`

## Important Files

- [Hyprland Lua](../../config/hypr/hyprland.lua)
- [Quickshell](../../config/quickshell/)
- [Home entry](../../home/home.nix)
- [Live links](../../home/modules/links.nix)
- [System modules](../../system/modules/)

## Decisions

- Hyprland is configured through `config/hypr/hyprland.lua`.
- `hyprland.conf`, `mocha.conf`, and `uwsm-at-cursor` were removed.
- Quickshell layer windows choose their screen when opened.
- Bar applets launch plainly through `uwsm app`; Hyprland rules place them near
  the cursor.
- Key repeat in Hyprland matches macOS feel.

## Next

- Audit remaining accent exceptions only when they visibly bother us.
- Extract shared QML pieces only when duplication starts slowing changes down.
