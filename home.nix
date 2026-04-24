{ config, pkgs, ... }:

{
  home.username = "skydive420dz";
  home.homeDirectory = "/home/skydive420dz";
  home.stateVersion = "26.05";
  programs.git.enable = true;
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        btw = "echo I use nixos, btw";
        nrs = "sudo nixos-rebuild switch --impure --flake ~/nixos-dotfiles#nixos";
        vim = "nvim";
      };
      profileExtra = ''
        if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
          exec start-hyprland
        fi
      '';
    };
  };

  imports = [
    ./modules/theme.nix
    # ./modules/nvim.nix
  ];

  home.file.".config/hypr".source = /home/skydive420dz/nixos-dotfiles/config/hypr;
  home.file.".config/waybar".source = /home/skydive420dz/nixos-dotfiles/config/waybar;
  home.file.".config/rofi".source = /home/skydive420dz/nixos-dotfiles/config/rofi;
  home.file.".config/kitty".source = /home/skydive420dz/nixos-dotfiles/config/kitty;
  home.file.".config/wofi".source = /home/skydive420dz/nixos-dotfiles/config/wofi;
  home.file.".config/yazi".source = /home/skydive420dz/nixos-dotfiles/config/yazi;
  wayland.windowManager.hyprland.systemd.enable = false;

}
