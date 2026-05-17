# Quickshell

This is the desktop shell layer: bar, OSD, launcher, clipboard, tray, media, and
small status surfaces.

The current `main` branch is the sober working shell. The old modular shell lives
on `prototype/quickshell-legacy` and the archived quickshell branches. Treat
those branches as reference material only: port useful ideas back deliberately,
one module at a time.

## Current Files

- [Shell root](../../config/quickshell/shell.qml)
- [Bar](../../config/quickshell/Bar.qml)
- [OSD](../../config/quickshell/Osd.qml)
- [Theme tokens](../../config/quickshell/Theme.qml)
- [QML module index](../../config/quickshell/qmldir)
- [Workspaces module](../../config/quickshell/modules/workspaces/Workspaces.qml)

## Commands

- `systemctl --user restart quickshell`
- `journalctl --user -u quickshell -f`

## Direction

Keep the shell small, calm, and portable. The bar is just a bar plus a few small
apps; it should not become a 300-file desktop framework unless the complexity
clearly earns its keep.

Prefer this target shape as we split things back out:

```text
config/quickshell/
  shell.qml
  qmldir
  root/
    Bar.qml
    Osd.qml
    Launcher.qml
    Clipboard.qml
  common/
    Theme.qml
    Metrics.qml
    Pill.qml
    IconButton.qml
    TextRow.qml
    PopoverPanel.qml
  modules/
    workspaces/
      Workspaces.qml
      WorkspaceButton.qml
    window/
      WindowTitle.qml
    media/
      Media.qml
      MediaButton.qml
    status/
      StatusCluster.qml
      Battery.qml
      Network.qml
      Bluetooth.qml
      Volume.qml
      Clock.qml
    tray/
      Tray.qml
      TrayItem.qml
    osd/
      OsdView.qml
    launcher/
      LauncherView.qml
      LauncherRow.qml
    clipboard/
      ClipboardView.qml
      ClipboardRow.qml
```

This is a direction, not a mandate to create empty folders. Split only when a
module is ready to move.

## Ownership Rules

- `root/` owns top-level windows and surfaces only. `shell.qml` should wire root
  windows together, not host module behavior.
- `common/` is for shared tokens and primitives only. It must not become a junk
  drawer for one-off component code.
- `modules/<name>/` owns the implementation details for that block: private
  helpers, local state, row components, timers, process calls, and popover
  behavior.
- Each block owns its own width, hover/open/selected state, click behavior,
  internal animation, and private click-out handling.
- The bar owns placement, global height, spacing between modules, and the visible
  bar input region.
- Global state is allowed only when multiple modules genuinely need it.

## Guardrails

- No module-specific state should live in `Bar.qml` once that module is split.
- No module should secretly resize, mask, or animate the whole bar.
- No full-screen invisible masks unless the surface is an explicit overlay or
  picker, and it must release clicks cleanly when closed.
- No phantom click areas: every layer should be as small as its visible,
  interactive surface unless there is a very clear reason.
- No module should reach into another module's private helper.
- Use shared theme tokens before local `Qt.rgba(...)` recipes.
- Keep fades, but be skeptical of height/width animation unless it explains a
  real spatial change.

## Refactor Plan

1. Start from the working shell on `main`.
2. Create a cleanup branch before moving files.
3. Split one module at a time.
4. After each slice, rebuild/restart and test clicks, hover, focus, and monitor
   behavior before continuing.
5. Commit each stable slice separately.

## Refactor Progress

- 2026-05-17: `modules/workspaces/Workspaces.qml` owns workspace state,
  `hyprctl workspaces -j` polling, Hyprland workspace events, rendering, and
  workspace click dispatch. `Bar.qml` only places `Workspaces {}`. The module
  keeps explicit implicit/Layout bounds and dispatches workspace clicks directly
  from the visible button. Delegate files that read outer IDs should use
  `pragma ComponentBehavior: Bound`.

## Known Lesson

The HDMI/HDR flicker investigation currently points at per-output `awww`
wallpaper behavior, not the shell alone. Even so, Quickshell layers have caused
real focus, click, and redraw problems before, so new tools must be checked for
phantom masks and oversized input regions before they are considered done.
