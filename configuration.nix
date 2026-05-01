{
  config,
  lib,
  pkgs,
  ...
}:

{
  # ============================================
  # IMPORTS
  # ============================================

  imports = [
    /etc/nixos/hardware-configuration.nix
    ./modules/nvim.nix
  ];

  # ============================================
  # BOOT CONFIGURATION
  # ============================================

  boot = {
    consoleLogLevel = 0;
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
    # Plymouth boot splash screen
    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = with pkgs; [
        (catppuccin-plymouth.override { variant = "mocha"; })
      ];
    };

    # Bootloader configuration
    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        graceful = true;
        consoleMode = "max"; # Matches Plymouth resolution to avoid flicker
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };

    # Kernel parameters (optimized for silent boot)
    kernelParams = [
      "video=efifb:1920x1080"
      "quiet"
      "splash"
      "loglevel=0" # Changed from 0 to 3 to effectively hide 'Info/Warning' text
      "acpi_os=linux"
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1" # The flicker killer
      "acpi_enforce_resources=lax"
      "acpi.log_level=0"
      "acpi=ht"
      "rd.udev.log_level=2" # Changed from 0 to 3
      "rd.systemd.show_status=false"
      "udev.log_priority=2" # Changed from 0 to 3
      "systemd.show_status=false"
      "vt.global_cursor_default=0"
      "console=tty0"
      "printk.devkmsg=off"
      "fbcon=vc:2-6" # Ensures splash stays until Hyprland is ready
      "fbcon=nodefer"

      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
  };

  # --- ADDED FOR SILENT TTY ---
  services.getty = {
    autologinUser = "skydive420dz";
    helpLine = ""; # Removes the 'Press Alt+F1' help line
  };

  # This overrides the TTY1 login to be completely invisible
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [
      "" # Clear default
      "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --autologin skydive420dz --skip-login --nonewline --noissue --noclear %I $TERM"
    ];
  };

  systemd.services.plymouth-quit = {
    serviceConfig.ExecStart = [
      ""
      # The '|| true' ensures the service doesn't "fail" if Plymouth is already gone
      "${pkgs.bash}/bin/bash -c '${pkgs.plymouth}/bin/plymouth quit --retain-splash || true'"
    ];
  };
  # ============================================
  # HARDWARE CONFIGURATION
  # ============================================

  # GPU & Graphics
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    # NVIDIA GPU with Prime (hybrid graphics)
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      nvidiaPersistenced = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      prime = {
        sync.enable = true;
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
        offload = {
          enable = false;
          enableOffloadCmd = false;
        };
      };
    };

    # Bluetooth support
    bluetooth = {
      enable = true;
      powerOnBoot = true; # Ensures the controller is active for the UI
      settings.General.Experimental = true; # Often required for modern BLE devices
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # ============================================
  # POWER MANAGEMENT
  # ============================================

  powerManagement.cpuFreqGovernor = "performance";

  services.tlp = {
    enable = true;
    settings = {
      STOP_CHARGE_THRESH_BAT1 = 90;
      START_CHARGE_THRESH_BAT1 = 75;
    };
  };

  # ============================================
  # AUDIO CONFIGURATION
  # ============================================

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    extraConfig = {
      pipewire."99-silent-bell.conf" = {
        "context.properties" = {
          "module.x11.bell" = false;
        };
      };
    };
  };

  # ============================================
  # NETWORK & CONNECTIVITY
  # ============================================

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # ============================================
  # LOCALIZATION & TIME
  # ============================================

  time.timeZone = "America/New_York";

  # ============================================
  # INPUT DEVICES
  # ============================================

  # In your system configuration.nix

  # 1. Ensure the package is available for D-Bus to find its definitions
  services.dbus.packages = [ pkgs.swayosd ];

  # 2. Add the explicit policy to allow the backend to talk to the server
  services.dbus.implementation = "broker"; # Optional: 'broker' is more robust for modern NixOS
  services.udev.packages = [ pkgs.swayosd ];

  systemd.services.swayosd-libinput-backend = {
    description = "SwayOSD Libinput Backend";
    # Ensures it waits for the hardware and basic system to be ready
    after = [
      "udev.service"
      "multi-user.target"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
      Restart = "on-failure";
      RestartSec = "3s"; # Wait 5 seconds before retrying to avoid the start-limit-hit
    };
  };

  services.libinput.enable = true;
  # ============================================
  # DISPLAY SERVER & WINDOW MANAGER
  # ============================================

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # ============================================
  # USER CONFIGURATION
  # ============================================

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };

  users.users.skydive420dz = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
    ]; # sudo access
    packages = with pkgs; [
      tree
    ];
  };

  programs.zsh.enable = true;

  # ============================================
  # APPLICATIONS & PROGRAMS
  # ============================================

  # Terminal & Shell
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "~.steam/root/compatibilitytools.d";
  };

  # Gaming
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  # Utilities
  programs.firefox.enable = true;
  programs.bat.enable = true;

  # AI/ML
  services.ollama = {
    enable = true;
    loadModels = [
      "llama3.2"
      "deepseek-r1:1.5b"
      "deepseek-r1:7b"
    ];
  };

  # ============================================
  # FONTS
  # ============================================

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.commit-mono
    nerd-fonts.fantasque-sans-mono
    font-awesome
  ];

  # ============================================
  # SYSTEM PACKAGES
  # ============================================

  environment.systemPackages = with pkgs; [
    # Core utilities
    libinput
    tmux
    vim
    lshw
    wget
    git
    neovim
    ripgrep
    fd
    tree
    tree-sitter

    # Terminal & UI
    lynx
    fzf

    # Development tools
    nil
    nixpkgs-fmt
    nodejs
    gcc
    c3-lsp

    # System monitoring & info
    fastfetch
    nitch
    lm_sensors

    # Media & multimedia
    ffmpeg-full
    mpv

    # Hardware & drivers
    bluez
    bluez-tools
    brightnessctl
    bluetui

    # System administration
    protonup-ng
    snip
  ];

  # ============================================
  # NIX CONFIGURATION
  # ============================================

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.05";
}
