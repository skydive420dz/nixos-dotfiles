{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    shellWrapperName = "y";
  };

  xdg.configFile = {
    "yazi/yazi.toml".source = ./programs/yazi-config/yazi.toml;
    "yazi/keymap.toml".source = ./programs/yazi-config/keymap.toml;
    "yazi/theme.toml".source = ./programs/yazi-config/theme.toml;
    "yazi/package.toml".source = ./programs/yazi-config/package.toml;
    "yazi/plugins".source = ./programs/yazi-config/plugins;
  };
}
