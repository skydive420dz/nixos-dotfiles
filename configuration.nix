{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    ./modules/nvim.nix
  ];

  # Use the systemd-boot EFI boot loader.

  boot = {
    initrd.verbose = false;
    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = with pkgs; [
        (catppuccin-plymouth.override { variant = "mocha"; })
      ];
    };
    loader = {
      systemd-boot = {
        enable = true;
        graceful = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [
      "video=efifb:1920x1080"
      "quiet"
      "splash"
      "acpi.log_level=0"
      "rd.udev.log_level=0"
      "udev.log_priority=0"
      "vt.global_cursor_default=0"
      "loglevel=0"
      "systemd.show_status=false"
      "console=tty0"
      "acpi=ht"
      "boot.shell_on_fail"
      "printk.devkmsg=off"
      "rd.systemd.show_status=false"
      "fbcon=nodefer"
    ];
  };

  powerManagement.cpuFreqGovernor = "performance";
  services.tlp = {
    enable = true;
    settings = {
      STOP_CHARGE_THRESH_BAT1 = 90;
      START_CHARGE_THRESH_BAT1 = 75;
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      open = true;
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
  };

  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  services.getty.autologinUser = "skydive420dz";

  # Configure network connections interactively with nmcli or nmtui.

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.skydive420dz = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  programs.firefox.enable = true;
  programs.gamemode.enable = true;

  # Stuff to make steam work.
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "~.steam/root/compatibilitytools.d";
  };

  # List packages installed in system profile.
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    wget
    foot
    waybar
    kitty
    waybar
    git
    hyprpaper
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    nitch
    rofi
    home-manager
    btop
    fastfetch
    fd
    fzf
    tree-sitter
    c3-lsp
    lua-language-server
    rust-analyzer
    libclang
    wl-clipboard
    mangohud
    protonup-ng
    alacritty
  ];
  programs.bat = {
    enable = true;
  };

  #Random stuff to make flakes work and lock the version:
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "26.05"; # Did you read the comment?
}
