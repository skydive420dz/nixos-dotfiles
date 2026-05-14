{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
  };

  xdg.configFile = {
    "yazi/yazi.toml".source = ../../config/yazi/yazi.toml;
    "yazi/keymap.toml".source = ../../config/yazi/keymap.toml;
    "yazi/theme.toml".source = ../../config/yazi/theme.toml;
    "yazi/package.toml".source = ../../config/yazi/package.toml;
    "yazi/plugins".source = ../../config/yazi/plugins;
  };
}
