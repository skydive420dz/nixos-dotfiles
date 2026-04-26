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
    ./modules/links.nix
  ];

  # --- SHELL CONFIGURATION (BASH) ---
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

    initExtra = ''
      [ -f "$HOME/.openai_key" ] && source "$HOME/.openai_key"
    '';

  };

  # --- SHELL CONFIGURATION (ZSH) ---
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
    };

    shellAliases = {
      btw = "echo I use nixos, btw";
      nrs = "sudo nixos-rebuild switch --impure --flake ~/nixos-dotfiles#nixos";
      vim = "nvim";
      ls = "ls --color=auto";
      cat = "bat";
    };

    # Note: Using initContent for 26.05 Unstable as requested by your build log

    # This is the new way to put content at the TOP of the file in 26.05
    # COMBINED BLOCK: Everything goes in here once
    initContent = lib.mkBefore ''
      # 1. Load OpenAI Key secretly (Must be first)
      if [ -f "$HOME/.openai_key" ]; then
        . "$HOME/.openai_key"
      fi

      # 2. Initialize Starship
      eval "$(starship init zsh)"

      # 3. Start Hyprland automatically if on TTY1
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec start-hyprland
      fi
    '';

  };

  # --- STARSHIP PROMPT ---
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$nix_shell$character";
      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol]($style) ";
      };
    };
  };

  # --- KITTY TERMINAL ---

  #  programs.kitty = {
  #    enable = true;
  #    # On newer Kitty versions, Mocha is built-in
  #    themeFile = "Catppuccin-Mocha";
  #
  #    font = {
  #      name = "JetBrainsMono Nerd Font";
  #      size = 12;
  #    };
  #
  #    settings = {
  #      confirm_os_window_close = 0;
  #      background_opacity = "0.95"; # Slight transparency to match your bar/blur
  #      window_padding_width = 10;
  #      scrollback_lines = 10000;
  #      enable_audio_bell = false;
  #    };
  #  };

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
      source = /home/skydive420dz/nixos-dotfiles/config/hypr/hyprland.conf
    '';
  };

  # --- SESSION VARIABLES ---
  home.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";

    GTK_THEME = "catppuccin-mocha-lavender-standard";
    XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
  };
}
