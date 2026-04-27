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
    initrd.verbose = false;
    extraModulePackages = [ pkgs.glibc ];

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
      systemd-boot = {
        enable = true;
        graceful = true;
        consoleMode = "max";
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };

    # Kernel parameters (optimized for silent boot)
    kernelParams = [
      "video=efifb:1920x1080"
      "quiet"
      "splash"
      "loglevel=0"
      "acpi_os=linux"
      "acpi_enforce_resources=lax"
      "acpi.log_level=0"
      "acpi=ht"
      "rd.udev.log_level=0"
      "rd.systemd.show_status=false"
      "udev.log_priority=0"
      "systemd.show_status=false"
      "vt.global_cursor_default=0"
      "console=tty0"
      "printk.devkmsg=off"
      "fbcon=nodefer"
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
    #    opengl = {
    #      enable = true;
    #      driSupport32Bit = true;
    #    };

    # NVIDIA GPU with Prime (hybrid graphics)
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
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
    bluetooth.enable = true;
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

  services.getty.autologinUser = "skydive420dz";

  users.users.skydive420dz = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # sudo access
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
    wl-clipboard

    # Terminal & UI
    lynx
    kitty
    waybar
    rofi
    swaynotificationcenter
    fzf

    # Development tools
    nil
    nixpkgs-fmt
    nodejs
    gcc
    c3-lsp

    # System monitoring & info
    btop
    fastfetch
    nitch
    nvtopPackages.full
    lm_sensors

    # Media & multimedia
    ffmpeg-full
    mpv

    # Hardware & drivers
    bluez
    bluez-tools
    brightnessctl

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

  system.stateVersion = "26.05";
}
