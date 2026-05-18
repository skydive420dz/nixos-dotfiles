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
- Portal config keeps GTK as a fallback, but disables `org.freedesktop.impl.portal.Inhibit` to avoid GTK ScreenSaver noise under Hyprland.
