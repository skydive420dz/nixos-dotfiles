let
  styles = builtins.fromJSON (builtins.readFile ./styles.json);
  style = styles.SkyDark;
  palette = style.palette;
  skyPalette = palette // {
    foreground = palette.fg;
    foregroundMuted = palette.fgAlt;
    background = palette.bg;
    backgroundAlt = palette.bgAlt;
    surface = palette.bgAlt;
    surfaceStrong = palette.base3;
    surfaceRaised = palette.base4;
    border = palette.base4;
    muted = palette.base6;
    dim = palette.base5;
    subtle = palette.base7;
    accent = palette.cyan;
    accentAlt = palette.blue;
    accentDim = palette.darkCyan;
    neutral = palette.fgAlt;
    danger = palette.red;
    success = palette.green;
    warning = palette.yellow;
    warm = palette.orange;
    baseLow = palette.base0;
    baseHigh = palette.base3;
  };
in
style // { palette = skyPalette; }
