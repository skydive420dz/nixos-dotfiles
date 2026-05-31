# NixOS Dotfiles

## Current

- Hyprland config is Lua-only.
- Quickshell owns bar, launcher, clipboard, OSD, and popovers.
- Sky theme selection is global runtime state owned by `scripts/theme-select`
  and helpers under `scripts/theme-select.d/`.
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
- Sky theme source data lives in `theme/styles.json`; generated runtime files
  live under `~/.config/theme/current/`.
- Units that grow past one small file move into category-aware module
  directories with a local `default.nix`; current examples are tmux and Neovim.

## Next

- [x] Document the global Sky theme ownership model.
- [x] List generated files vs source files.
- [x] Map which apps are runtime-themed vs rebuild-themed.
- [x] Clean up `scripts/theme-select` so it stops feeling like one giant
  generator carpet.
- [x] Continue global theme coverage audit.
- [ ] Convert docs from Markdown to Org.
- [ ] Quickshell project structure/QML metadata follow-up.
- [ ] NVF reassessment or replacement path.
