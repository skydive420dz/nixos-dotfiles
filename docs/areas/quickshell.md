# Quickshell

This is the desktop shell layer: bar, OSD, launcher, clipboard, tray, media, and
small status surfaces.

The current `main` branch is the sober working shell. The old modular shell lives
on `prototype/quickshell-legacy` and the archived quickshell branches. Treat
those branches as reference material only: port useful ideas back deliberately,
one module at a time.

## Current Files

- [Shell root](../../config/quickshell/shell.qml)
- [Bar root surface](../../config/quickshell/root/Bar.qml)
- [OSD root surface](../../config/quickshell/root/Osd.qml)
- [Theme tokens](../../config/quickshell/Theme.qml)
- [QML module index](../../config/quickshell/qmldir)
- [Media module](../../config/quickshell/modules/media/Media.qml)
- [Media controller](../../config/quickshell/modules/media/MediaController.qml)
- [OSD view](../../config/quickshell/modules/osd/OsdView.qml)
- [Status cluster](../../config/quickshell/modules/status/StatusCluster.qml)
- [Workspaces module](../../config/quickshell/modules/workspaces/Workspaces.qml)
- [Window title module](../../config/quickshell/modules/window/WindowTitle.qml)

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
- Hyprland is Lua-first now. Do not use old hyprlang dispatcher strings such as
  `workspace 3` or `exec kitty` from Quickshell. Use Lua dispatcher expressions
  such as `hl.dsp.focus({ workspace = "3" })` through `Hyprland.dispatch(...)`
  or `hyprctl dispatch 'hl.dsp....'`.

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
  keeps explicit implicit/Layout bounds. Workspace switching uses
  `Hyprland.dispatch("hl.dsp.focus({ workspace = ... })")`, because Hyprland
  0.55/Lua no longer accepts the old `hyprctl dispatch workspace N` shape.
  Delegate files that read outer IDs should use `pragma ComponentBehavior: Bound`.
- 2026-05-17: `modules/window/WindowTitle.qml` owns active-window polling,
  Hyprland active-window events, title normalization, and title rendering.
  `Bar.qml` only places `WindowTitle {}`. This module has no pointer handlers or
  masks; its bounds are the visible pill only.
- 2026-05-17: `modules/media/Media.qml` owns the visible media pill and player
  controls. `modules/media/MediaController.qml` lives once at `ShellRoot` and
  owns player selection plus the `media.playPause` IPC target, avoiding duplicate
  `IpcHandler` registration from per-monitor bars. Inactive media has zero layout
  width, and prev/next only accept clicks when the player supports them. The
  prev/play/next controls use fixed-width icon wells so disabled controls stay
  visually present instead of collapsing or blending into the border. The root
  controller id must not share the same name as `Bar.mediaController`, or the
  delegate binding can shadow itself and leave media hidden.
- 2026-05-17: `modules/status/StatusCluster.qml` owns the current status
  behavior unchanged: clock, volume, network traffic, bluetooth, battery,
  battery plug/unplug OSD triggers, status polling, and click launchers for
  `nmtui`, `bluetui`, and `wiremix`. `Bar.qml` only places `StatusCluster {}`.
  Polling is intentionally unchanged in the extraction slice; optimize it only
  after the module passes live testing.
- 2026-05-17: Status polling was split after the extraction passed live testing.
  Keep the fast loop limited to cheap, visible-changing state: volume and
  traffic every 2s. Slower probes now run separately: network identity every
  15s, battery every 10s, and bluetooth every 30s. This keeps service-heavy
  checks like `nmcli` and `bluetoothctl` out of the hot path without changing
  bar geometry or click targets.
- 2026-05-17: Network traffic labels use fixed four-character rates so the
  status pill does not visually twitch as traffic changes. Examples: `0000`,
  `012K`, `1.2M`, `042M`, `99M+`.
- 2026-05-17: The status pill grew from 324px to 340px and the network field
  minimum grew from 64px to 80px to fit the fixed-width traffic labels without
  clipping the clock/status fields.
- 2026-05-17: `Osd.qml` now owns only the top-level overlay layer, namespace,
  focus policy, and mask. `modules/osd/OsdView.qml` owns the signal watcher,
  JSON load process, hide timer, payload state, and card rendering. The root OSD
  mask still points to the visible card through `osdView.maskItem`, so this split
  should not expand the clickable/input region.
- 2026-05-17: Top-level surfaces moved into `root/`: `root/Bar.qml` and
  `root/Osd.qml`. `shell.qml` imports `root/`, `qmldir` now only exports the
  `Theme` singleton, and the root surfaces still own the only bar/OSD
  `PanelWindow` and mask definitions.

## Test Notes

- 2026-05-17: Workspace split tested live. Workspaces render, update, and switch
  using Lua Hyprland dispatch. The visible button hitboxes match the interactive
  area.
- 2026-05-17: Window title split tested live. Title updates across window focus
  and workspace changes, with no visible module interference.
- 2026-05-17: Media split tested live. Media pill appears and collapses with
  active player state, play/pause works, prev/next controls work, and the
  duplicate `media` IPC handler warning is gone after restart. Remaining Firefox
  MPRIS `Position` DBus warnings appear to be player-side churn, not shell
  structure breakage.
- 2026-05-17: Status cluster split tested live. Configuration loads cleanly after
  restart and status behavior appears intact: clock/status rendering, network,
  bluetooth, volume, battery, and app-launch clicks continue to work. Polling
  remains unchanged from the pre-split implementation.
- 2026-05-17: Status polling split tested live after `nrs`. Quickshell reloads
  cleanly with `Configuration Loaded`, and the latest journal output shows no new
  status errors. Historical media/import warnings in the same journal tail were
  from earlier iterations, not the polling split.
- 2026-05-17: Fixed-width network traffic labels tested live after reload.
  Quickshell reports `Configuration Loaded` with no new warnings from the
  formatter-only change.
- 2026-05-17: Tuned status traffic width tested live after build/reload. The
  340px pill and 80px network field are good for now, with clean reload and
  build results.
- 2026-05-17: OSD view split tested live. Volume, brightness, and battery OSD
  behavior passed, and Quickshell reloads cleanly with `Configuration Loaded`.

## Known Lesson

The HDMI/HDR flicker investigation currently points at per-output `awww`
wallpaper behavior, not the shell alone. Even so, Quickshell layers have caused
real focus, click, and redraw problems before, so new tools must be checked for
phantom masks and oversized input regions before they are considered done.
