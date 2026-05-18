{ inputs, pkgs, ... }:

let
  hyprlandPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in

{
  programs.hyprland = {
    enable = true;
    package = hyprlandPkgs.hyprland;
    portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;
    withUWSM = true;
    xwayland.enable = true;
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
