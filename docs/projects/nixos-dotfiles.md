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
- [Module structure](../areas/modules.md)

## Decisions

- Hyprland is configured through `config/hypr/hyprland.lua`.
- `hyprland.conf`, `mocha.conf`, and `uwsm-at-cursor` were removed.
- Quickshell layer windows choose their screen when opened.
- Bar applets launch plainly through `uwsm app`; Hyprland rules place them near
  the cursor.
- Key repeat in Hyprland matches macOS feel.
- Units that grow past one small file move into category-aware module
  directories with a local `default.nix`; current examples are tmux and Neovim.

## Next

- Audit remaining accent exceptions only when they visibly bother us.
- Extract shared QML pieces only when duplication starts slowing changes down.
