# Per-output `awww` wallpaper on HDMI HDR monitor causes flicker/artifacts

## Summary

On a dual-monitor Hyprland setup, setting wallpapers with per-output `awww img --outputs ...`
appears to trigger intermittent compositor flicker/artifacts on the external HDMI monitor.
Using a single global `awww img ...` command with the same animated wallpaper and transition
avoids the issue.

The internal eDP display does not show the same problem. The issue appears tied to the
external HDMI/HDR output path and per-output wallpaper assignment.

## Environment

- Machine: MSI Bravo 15 C7V
- OS: NixOS `26.05.20260510.da5ad66 (Yarara)`
- Kernel: `Linux nixos 6.18.28 #1-NixOS SMP PREEMPT_DYNAMIC Fri May 8 06:40:23 UTC 2026 x86_64 GNU/Linux`
- CPU: AMD Ryzen 5 7535HS with Radeon Graphics
- GPU modules loaded: `nvidia`, `nvidia_drm`, `nvidia_modeset`, `nvidia_uvm`, `amdgpu`
- `awww`: `0.12.1`
- Hyprland: `0.55.0`, commit `805f7bf48e46dcab20c0b45844ae36aac354b4bd`

Hyprland library versions:

```text
Hyprgraphics: built against 0.5.1
Hyprutils: built against 0.13.1
Hyprcursor: built against 0.1.13
Hyprlang: built against 0.6.8
Aquamarine: built against 0.11.0
```

## Monitor Setup

External monitor:

```text
Monitor HDMI-A-1:
  3440x1440@100.00000 at 1920x0
  make/model: YSN Z34D
  scale: 1.00
  currentFormat: XBGR2101010
  colorManagementPreset: hdr
  sdrBrightness: 0.60
  sdrSaturation: 1.15
  sdrMaxLuminance: 450
  vrr: false
```

Internal monitor:

```text
Monitor eDP-1:
  1920x1080@144.00301 at 0x0
  make/model: Chimei Innolux Corporation 0x1521
  scale: 1.00
  currentFormat: XBGR2101010
  colorManagementPreset: srgb
  sdrBrightness: 0.70
  sdrSaturation: 1.11
  sdrMaxLuminance: 400
  vrr: true
```

Relevant Hyprland monitor config:

```lua
hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@144",
	position = "0x0",
	scale = 1,
	bitdepth = 10,
	sdr_eotf = "gamma22",
	sdrbrightness = 0.7,
	sdrsaturation = 1.11,
	supports_wide_color = 1,
	sdr_min_luminance = 0.001,
	sdr_max_luminance = 400,
	vrr = 1,
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "3440x1440@100",
	position = "1920x0",
	scale = 1,
	bitdepth = 10,
	cm = "hdr",
	sdrbrightness = 0.6,
	sdrsaturation = 1.15,
	supports_wide_color = 1,
	supports_hdr = 1,
	sdr_min_luminance = 0.001,
	sdr_max_luminance = 450,
	vrr = 1,
})
```

## Reproduction

With both monitors connected, start `awww` using per-output wallpaper commands:

```sh
uwsm app -- awww img --outputs eDP-1 /home/skydive420dz/nixos-dotfiles/wallpapers/wallpaper-003.gif --transition-type fade
uwsm app -- awww img --outputs HDMI-A-1 /home/skydive420dz/nixos-dotfiles/wallpapers/wallpaper-008.jpg --transition-type fade
```

Observed behavior:

- The external HDMI monitor shows intermittent compositor flicker/artifacts.
- Artifacts are easiest to notice on an empty desktop/plain background.
- The internal eDP panel is stable.
- The behavior looked like compositor/layer glitches at first, but persisted after simplifying the shell.

Then stop/reset `awww` and set one global wallpaper instead:

```sh
uwsm app -- awww img /home/skydive420dz/nixos-dotfiles/wallpapers/wallpaper-003.gif --transition-type fade
```

Observed behavior:

- Flicker/artifacts stop.
- HDR can remain enabled on `HDMI-A-1`.
- The same transition type (`fade`) is kept.
- The desktop stays stable with the global wallpaper command.

## Expected Behavior

Per-output wallpaper assignment should not cause flicker/artifacts on the external HDMI HDR monitor.

## Actual Behavior

Using per-output wallpaper assignment appears to trigger intermittent visual artifacts/flicker on the
HDMI HDR output. Using a global wallpaper assignment avoids the issue.

## Notes

- The external monitor uses HDR color management and 10-bit format (`XBGR2101010`).
- The issue appears output-specific: eDP is stable, HDMI is affected.
- The current workaround is to use a single global `awww img ...` call instead of separate
  `--outputs` calls.
- `lspci` was not available during data collection, but GPU-related loaded modules include both
  NVIDIA and AMDGPU modules. Raw command outputs are available in the attached report bundle.

## Current Workaround

Current working Hyprland startup command:

```lua
hl.exec_cmd(
	"uwsm app -- awww img /home/skydive420dz/nixos-dotfiles/wallpapers/wallpaper-003.gif --transition-type fade"
)
```
