{ config, pkgs, ... }:

{
  home.username = "skydive420dz";
  home.homeDirectory = "/home/skydive420dz";
  home.stateVersion = "26.05";
  programs.git.enable = true;
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use nixos, btw";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
      vim = "nvim";
    };

    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec start-hyprland
      fi
    '';
  };

  imports = [
    ./modules/theme.nix
    # ./modules/nvim.nix
  ];

  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/waybar".source = ./config/waybar;
  home.file.".config/foot".source = ./config/foot;
  home.file.".config/nvim".source = ./config/nvim;
  home.file.".config/rofi".source = ./config/rofi;
  home.file.".config/alacritty".source = ./config/alacritty;
  wayland.windowManager.hyprland.systemd.enable = false;

}
