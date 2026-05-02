{ config, ... }:

let
  # A helper function to make links cleaner
  link = path: config.lib.file.mkOutOfStoreSymlink "/home/skydive420dz/nixos-dotfiles/${path}";
in
{
  home.file = {
    # Bulk link whole directories
    ".config/waybar".source = link "config/waybar";
    ".config/kitty".source = link "config/kitty";
    ".config/swayosd".source = link "config/swayosd";
    ".config/yazi".source = link "config/yazi";
    ".config/qutebrowser".source = link "config/qutebrowser";

    # Links your scripts folder to ~/.config/scripts
    ".config/scripts".source = link "scripts";

    # Specific sub-files for Hyprland
    ".config/hypr/hyprpaper.conf".source = link "config/hypr/hyprpaper.conf";
    ".config/hypr/mocha.conf".source = link "config/hypr/mocha.conf";

    # Link individual files for SwayNC to avoid the directory conflict
    ".config/swaync/config.json".source = link "config/swaync/config.json";
    ".config/swaync/style.css".source = link "config/swaync/style.css";

    # Link individual files for Zsh to avoid the directory conflict
    #    ".config/zsh/prompt.zsh".source = link "config/zsh/prompt.zsh";
  };
}
