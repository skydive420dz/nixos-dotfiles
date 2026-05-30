let
  styles = builtins.fromJSON (builtins.readFile ./styles.json);
in
styles.SkyDark
