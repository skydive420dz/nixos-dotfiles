{ pkgs }:

let
  theme = import ./tokens.nix;
  s = theme.semantic;

  stripHash = color: builtins.substring 1 6 color;
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "sky-plymouth-theme";
  version = "1.0.0";

  nativeBuildInputs = [
    pkgs.imagemagick
  ];

  dontUnpack = true;

  installPhase = ''
    set -euo pipefail

    theme_dir="$out/share/plymouth/themes/sky"
    mkdir -p "$theme_dir"

    cat > "$theme_dir/sky.plymouth" <<EOF
[Plymouth Theme]
Name=Sky
Description=Sky boot splash
ModuleName=two-step

[two-step]
Font=Noto Sans 12
TitleFont=Noto Sans Light 30
ImageDir=$theme_dir
DialogHorizontalAlignment=.5
DialogVerticalAlignment=.5
TitleHorizontalAlignment=.5
TitleVerticalAlignment=.5
HorizontalAlignment=.5
VerticalAlignment=.5
WatermarkHorizontalAlignment=.5
WatermarkVerticalAlignment=.5
Transition=none
TransitionDuration=0.0
BackgroundStartColor=0x${stripHash s.background}
BackgroundEndColor=0x${stripHash s.background}
ProgressBarBackgroundColor=0x${stripHash s.surfaceStrong}
ProgressBarForegroundColor=0x${stripHash s.accent}
MessageBelowAnimation=true

[boot-up]
UseEndAnimation=false

[shutdown]
UseEndAnimation=false

[reboot]
UseEndAnimation=false
EOF

    magick -size 8x8 "xc:${s.accent}" "$theme_dir/bullet.png"
    magick -size 260x42 xc:none \
      -fill "${s.surface}" \
      -stroke "${s.border}" \
      -strokewidth 1 \
      -draw "roundrectangle 0,0 259,41 8,8" \
      "$theme_dir/entry.png"

    for icon in capslock keyboard lock; do
      magick -size 1x1 xc:none "$theme_dir/$icon.png"
    done

    dot_color() {
      if [ "$1" = "$2" ]; then
        printf '%s\n' "${s.accent}"
      else
        printf '%s\n' "${s.border}"
      fi
    }

    make_frame() {
      frame="$1"
      magick -size 32x32 xc:none \
        -fill "$(dot_color "$frame" 0)" -draw "circle 16,4 18,4" \
        -fill "$(dot_color "$frame" 1)" -draw "circle 26,10 28,10" \
        -fill "$(dot_color "$frame" 2)" -draw "circle 26,22 28,22" \
        -fill "$(dot_color "$frame" 3)" -draw "circle 16,28 18,28" \
        -fill "$(dot_color "$frame" 4)" -draw "circle 6,22 8,22" \
        -fill "$(dot_color "$frame" 5)" -draw "circle 6,10 8,10" \
        "$theme_dir/throbber-$frame.png"
    }

    for frame in 0 1 2 3 4 5; do
      make_frame "$frame"
    done
  '';
}
