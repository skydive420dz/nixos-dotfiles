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
    ./modules
  ];

  # ============================================
  # HARDWARE CONFIGURATION
  # ============================================

  # Bluetooth support
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # Ensures the controller is active for the UI
    settings.General.Experimental = true; # Often required for modern BLE devices
  };

  # ============================================
  # POWER MANAGEMENT
  # ============================================

  services.tlp = {
    enable = true;
    settings = {
      STOP_CHARGE_THRESH_BAT1 = 90;
      START_CHARGE_THRESH_BAT1 = 75;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
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
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "~./steam/root/compatibilitytools.d";
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
