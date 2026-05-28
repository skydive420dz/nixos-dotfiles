# Hyprland

## Files

- [Lua config](../../config/hypr/hyprland.lua)
- [Hyprland system module](../../system/modules/desktop/hyprland.nix)
- [Hyprland home module](../../home/modules/desktop/hyprland.nix)

## Commands

- `hyr reload`
- `hyr version`
- `hyr monitors`
- `hyr eval 'hl.dispatch(hl.dsp.focus({ monitor = "eDP-1" }))'`

## Notes

- Hyprland 0.55 uses Lua config in this setup.
- Prefer native Lua rules over shell helpers.
- Old-style dispatch strings can be interpreted badly by Lua config paths; use `hyr eval` with Lua dispatch where needed.
- Floating applets use persistent window rules for size/placement.
- The Wi-Fi applet rule intentionally matches both `nmtui` and `wlctl`; both are
  launched through Kitty classes and should share the same centered 600x600
  popup behavior.
- Portal config keeps GTK as a fallback, but disables `org.freedesktop.impl.portal.Inhibit` to avoid GTK ScreenSaver noise under Hyprland.
- Hyprland exports `HYPRLAND_INSTANCE_SIGNATURE` through UWSM on startup, but long-lived tmux servers can keep a stale environment. If plain `hyprctl` fails inside tmux, refresh tmux from a fresh Hyprland shell or use `hyr` for stale/remote shells.
