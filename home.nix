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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # This replaces the need for manual OhMyZsh config
    history.size = 10000;

    shellAliases = {
      nrs = "sudo nixos-rebuild switch --impure --flake ~/nixos-dotfiles#nixos";
      vim = "nvim";
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
  wayland.windowManager.hyprland.systemd.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Nix translates this attribute set into the monitorv2 { ... } block
      monitorv2 = {
        output = "eDP-1";
        mode = "1920x1080@144";
        position = "0x0";
        scale = 0.83;
        bitdepth = 10;
        cm = "hdr";
        sdrbrightness = 0.7;
        sdrsaturation = 1.11;
        supports_wide_color = 1;
        sdr_min_luminance = 0.001;
        sdr_max_luminance = 400;
      };

      # Keeping your render settings managed here as well
      render = {
        direct_scanout = 1;
        cm_auto_hdr = 1;
        cm_sdr_eotf = 2;
      };
    };
  };

}
