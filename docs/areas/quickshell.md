# Quickshell

## Files

- [Shell root](../../config/quickshell/shell.qml)
- [Bar](../../config/quickshell/Bar.qml)
- [Theme tokens](../../config/quickshell/theme/Mocha.qml)
- [Layout tokens](../../config/quickshell/theme/Style.qml)

## Commands

- `systemctl --user restart quickshell`
- `journalctl --user -u quickshell -f`

## Notes

- Use shared theme tokens before local `Qt.rgba(...)` recipes.
- Launcher and Clipboard are single `PanelWindow`s; set `screen` when opening.
- Keep fades, but be skeptical of height/width animation unless it explains a spatial change.
- Commit small visual passes separately.
