let
  styles = builtins.fromJSON (builtins.readFile ./styles.json);
  themeLib = import ./lib.nix;
in
themeLib.forStyle styles.SkyDark
