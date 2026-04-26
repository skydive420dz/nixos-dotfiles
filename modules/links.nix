{ config, ... }:

let
  # A helper function to make links cleaner
  link = path: config.lib.file.mkOutOfStoreSymlink "/home/skydive420dz/nixos-dotfiles/${path}";
in
{
  home.file = {
    # Bulk link whole directories
    ".config/waybar".source = link "config/waybar";
    ".config/rofi".source = link "config/rofi";
    ".config/kitty".source = link "config/kitty";
    ".config/wofi".source = link "config/wofi";
    ".config/yazi".source = link "config/yazi";
    ".config/qutebrowser".source = link "config/qutebrowser";

    # Links your scripts folder to ~/.config/scripts
    ".config/scripts".source = link "scripts";

    # Specific sub-files for Hyprland
    ".config/hypr/mocha.conf".source = link "config/hypr/mocha.conf";
    ".config/hypr/hyprpaper.conf".source = link "config/hypr/hyprpaper.conf";
  };
}
