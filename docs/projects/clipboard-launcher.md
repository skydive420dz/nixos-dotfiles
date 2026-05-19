# Clipboard and Launcher

## Current

- Launcher and clipboard are separate Quickshell overlays.
- Both set `PanelWindow.screen` when opened so they follow the focused/current
  monitor.
- Clipboard has image previews and keyboard scrolling.

## Commands

- `systemctl --user restart quickshell`
- `~/.config/scripts/launcher-toggle`
- `~/.config/scripts/clipboard-toggle`

## Important Files

- [Launcher](../../config/quickshell/Launcher.qml)
- [Clipboard](../../config/quickshell/Clipboard.qml)
- [Launcher toggle](../../scripts/launcher-toggle)
- [Clipboard toggle](../../scripts/clipboard-toggle)

## Decisions

- Do not merge clipboard into launcher until focus restoration is understood
  cleanly.
- Avoid runtime focus helpers for overlay placement.
- Use Quickshell screen binding for layer windows.

## Next

- Revisit unified source search only after the separate tools feel boring and
  reliable.
