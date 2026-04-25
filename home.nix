{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.username = "skydive420dz";
  home.homeDirectory = "/home/skydive420dz";
  home.stateVersion = "26.05";

  programs.git.enable = true;

  # --- IMPORTS ---
  imports = [
    ./modules/theme.nix
    ./modules/links.nix # This now handles all your "Instant Edit" symlinks
  ];

  # --- SHELL CONFIGURATION ---
  programs.bash = {
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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # High-performance history settings
    history = {
      size = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
    };

    # Your custom aliases (matching your Bash ones)
    shellAliases = {
      btw = "echo I use nixos, btw";
      nrs = "sudo nixos-rebuild switch --impure --flake ~/nixos-dotfiles#nixos";
      vim = "nvim";
      ls = "ls --color=auto";
      cat = "bat"; # Since you have 'bat' enabled in your config
    };

    # This part handles the "Look" - we'll use Starship instead of OhMyZsh for speed
    initExtra = ''
      # Start Hyprland automatically if on TTY1
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec start-hyprland
      fi
    '';
  };

  # Starship: A lightning-fast, modular prompt (Matches your Nerd Font)
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    # Customizing it to be minimal and clean
    settings = {
      add_newline = false;
      format = "$directory$git_branch$symbol$character";
    };
  };

  # --- HYPRLAND CONFIGURATION ---
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      monitorv2 = {
        output = "eDP-1";
        mode = "1920x1080@144";
        position = "0x0";
        scale = 1;
        bitdepth = 10;
        cm = "hdr";
        sdrbrightness = 0.7;
        sdrsaturation = 1.11;
        supports_wide_color = 1;
        sdr_min_luminance = 0.001;
        sdr_max_luminance = 400;
      };

      render = {
        direct_scanout = 1;
        cm_auto_hdr = 1;
        cm_sdr_eotf = 2;
      };
    };

    extraConfig = ''
      source = ~/.config/hypr/mocha.conf
      source = ~/.config/hypr/hyprpaper.conf
      # Direct path to your main config in the dotfiles repo
      source = /home/skydive420dz/nixos-dotfiles/config/hypr/hyprland.conf
    '';
  };

  # --- SESSION VARIABLES ---
  home.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    GTK_THEME = "Adwaita";
    GTK_ICON_THEME = "Adwaita";
    HYPRCURSOR_SIZE = "24";
  };
}
