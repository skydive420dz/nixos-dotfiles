# ============================================
# BOOT CONFIGURATION — NixOS
# ============================================
# Quiet native boot retaining the firmware framebuffer until Hyprland.
# TTY1 auto-logs in as skydive420dz with no visible prompt or getty text.
# Diagnostics remain in the journal while fbcon keeps TTY1 visually untouched.

{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  boot = {
    consoleLogLevel = 0;

    initrd = {
      verbose = false;
      systemd.enable = true;
    };

    # ── Bootloader ──────────────────────────────────────────────────────────
    loader = {
      timeout = 0;
      systemd-boot = {
        # Lanzaboote replaces NixOS' systemd-boot module while still using a
        # systemd-boot based flow under Secure Boot.
        enable = lib.mkForce false;
        graceful = true;
        consoleMode = "max"; # avoid a firmware-framebuffer mode switch
        editor = false; # disable boot entry editing (security)
      };
      efi.canTouchEfiVariables = true;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    # ── Kernel parameters ───────────────────────────────────────────────────
    # nvidia-drm and NVreg params live in modules/gpu/nvidia-hybrid.nix
    kernelParams = [
      "video=efifb:1920x1080"
      "quiet"
      "acpi_enforce_resources=lax"
      "rd.udev.log_level=info"
      "rd.systemd.show_status=false"
      "udev.log_priority=info"
      "systemd.show_status=false"
      "vt.global_cursor_default=0"
      "console=tty0"
      "printk.devkmsg=on"
      "fbcon=vc:2-6" # keep TTY1 on the firmware framebuffer until Hyprland
      "fbcon=nodefer"
    ];
  };

  # ── Silent TTY1 autologin ───────────────────────────────────────────────
  # No login prompt, no help line, no issue text — completely invisible.
  services.getty = {
    autologinUser = "skydive420dz";
    helpLine = "";
  };

  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [
      "" # clear default
      "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --autologin skydive420dz --skip-login --nonewline --noissue --noclear %I $TERM"
    ];
  };
}
