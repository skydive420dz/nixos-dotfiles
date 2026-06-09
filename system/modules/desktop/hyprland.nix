{ inputs, pkgs, ... }:

let
  hyprlandPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in

{
  environment.systemPackages = [
    pkgs.hyprpolkitagent
  ];

  programs.hyprland = {
    enable = true;
    package = hyprlandPkgs.hyprland;
    portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;
    withUWSM = true;
    xwayland.enable = true;
  };

  systemd.user.services.hyprpolkitagent = {
    description = "Hyprland Polkit Authentication Agent";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
    serviceConfig = {
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Slice = "session.slice";
      Restart = "on-failure";
      TimeoutStopSec = 5;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      hyprlandPkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
      # GTK's Inhibit portal asks org.freedesktop.ScreenSaver, which Hyprland
      # does not own; disable only that noisy interface and keep GTK fallbacks.
      "org.freedesktop.impl.portal.Inhibit" = [ "none" ];
    };
  };
}
