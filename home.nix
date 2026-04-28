{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.username = "skydive420dz";
  home.homeDirectory = "/home/skydive420dz";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    kitty # Add this here
    btop # Add this for your system monitor
    nvtopPackages.full # Add this for your GPU monitor
    yazi
    qutebrowser
    hyprpaper
    psmisc # This provides killall
    awww
    libnotify
    wl-clipboard
    waybar
    swaynotificationcenter
    # ... any other apps you want installed
  ];

  programs.git.enable = true;

  imports = [
    ./modules/theme.nix
    ./modules/links.nix
    ./modules/rofi.nix
  ];

  # --- SHELL CONFIGURATION (BASH) ---
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use nixos, btw";
      nrs = "sudo nixos-rebuild switch --impure --flake ~/nixos-dotfiles#nixos";
      vim = "nvim";
    };
    initExtra = ''
      [ -f "$HOME/.openai_key" ] && source "$HOME/.openai_key"
    '';
    profileExtra = ''
      if uwsm check may-start; then
        exec uwsm start hyprland-uwsm.desktop
      fi
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
      y = "y"; # Optional: makes the y function feel like a first-class alias

      # Monitoring aliases that trigger your Hyprland floating rules
      btop = "kitty --title btop_float -e btop";
      nvtop = "kitty --title nvtop_float -e nvtop";

    };

    initContent = lib.mkBefore ''
      # 1. Load OpenAI Key secretly
      if [ -f "$HOME/.openai_key" ]; then
        . "$HOME/.openai_key"
      fi

      # 2. Initialize Starship
      eval "$(starship init zsh)"

      # 3. Start Hyprland with UWSM automatically on TTY1
      if uwsm check may-start; then
        exec uwsm start hyprland-uwsm.desktop
      fi

      # 4. Yazi CWD Wrapper (y command)
      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }
    '';
  };

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

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha";
      theme_background = false; # Set to true if you want a solid background
    };
  };

  # --- BROWSER CONFIGURATION ---

  #programs.qutebrowser = {
  #  enable = true;
  # Custom settings to keep it minimal
  #    settings = {
  #      "colors.webpage.preferred_color_scheme" = "dark";
  #      "tabs.position" = "left"; # Matches your vertical/minimal vibe
  #    };
  #};

  # --- HYPRLAND CONFIGURATION ---

  # Create a systemd service for awww-daemon
  systemd.user.services.awww-daemon = {
    Unit = {
      Description = "Awww Wallpaper Daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      targets = [ "graphical-session.target" ]; # UWSM reaches this target
    };
  };

  services.swaync.enable = true; # For swaynotificationcenter

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
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
      source = ~/nixos-dotfiles/config/hypr/hyprland.conf
    '';
  };

  home.sessionVariables = {
    GTK_THEME = "catppuccin-mocha-lavender-standard";
    XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";

    # --- NVIDIA Specifics ---
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # --- GPU Selection (Aquamarine/Hyprland) ---
    # This tells Hyprland to use the NVIDIA card (card1) as the primary renderer.
    # If you get a black screen, swap the order to "/dev/dri/card0:/dev/dri/card1"
    AQ_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card2";

    # --- Wayland Fixes ---
    NVD_BACKEND = "direct"; # Better performance for NVIDIA on Wayland
    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # Fixes flickering in Discord/VSCode

  };
}
