# ============================================
# BOOT CONFIGURATION — NixOS
# ============================================
# Silent boot with Plymouth splash (Catppuccin Mocha theme).
# TTY1 auto-logs in as skydive420dz with no visible prompt or getty text.
# Plymouth is held until Hyprland is ready via fbcon reservation.

{
  config,
  pkgs,
  lib,
  ...
}:

{
  boot = {
    consoleLogLevel = 0;

    initrd = {
      verbose = false;
      systemd.enable = true;
    };

    # ── Plymouth splash screen ──────────────────────────────────────────────
    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = with pkgs; [
        (catppuccin-plymouth.override { variant = "mocha"; })
      ];
    };

    # ── Bootloader ──────────────────────────────────────────────────────────
    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        graceful = true;
        consoleMode = "max"; # match Plymouth resolution to avoid flicker
        editor = false; # disable boot entry editing (security)
      };
      efi.canTouchEfiVariables = true;
    };

    # ── Kernel parameters ───────────────────────────────────────────────────
    # nvidia-drm and NVreg params live in modules/nvidia.nix
    kernelParams = [
      "video=efifb:1920x1080"
      "quiet"
      "splash"
      "loglevel=0"
      "acpi_os=linux"
      "acpi_enforce_resources=lax"
      "acpi.log_level=0"
      "acpi=ht"
      "rd.udev.log_level=2"
      "rd.systemd.show_status=false"
      "udev.log_priority=2"
      "systemd.show_status=false"
      "vt.global_cursor_default=0"
      "console=tty0"
      "printk.devkmsg=off"
      "fbcon=vc:2-6" # reserves framebuffer consoles so Plymouth holds until Hyprland
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

  # ── Plymouth quit ───────────────────────────────────────────────────────
  # Retain splash until the desktop is ready; || true prevents service
  # failure if Plymouth has already exited.
  systemd.services.plymouth-quit = {
    serviceConfig.ExecStart = [
      ""
      "${pkgs.bash}/bin/bash -c '${pkgs.plymouth}/bin/plymouth quit --retain-splash || true'"
    ];
  };
}
