{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    adwaita-icon-theme
    gnome-themes-extra
  ];

  gtk = {
    enable = true;
    theme.name = "Adwaita";
    iconTheme.name = "Adwaita";
    colorScheme = "dark";
    #    cursorTheme = {
    #      name = "Adwaita";
    #      package = pkgs.adwaita-icon-theme;
    #      size = 24;
    #    };
  };

  xdg.configFile."gtk-2.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Adwaita
    gtk-icon-theme-name=Adwaita
    gtk-cursor-theme-size=24
    gtk-application-prefer-dark=1
  '';

  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Adwaita
    gtk-icon-theme-name=Adwaita
    gtk-cursor-theme-size=24
    gtk-application-prefer-dark=1
  '';

  xdg.configFile."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Adwaita
    gtk-icon-theme-name=Adwaita
    gtk-cursor-theme-size=24
    gtk-application-prefer-dark=1
  '';

  #  home.sessionVariables = {
  #    XCURSOR_THEME = "Adwaita";
  #    XCURSOR_SIZE = "24";
  #  };
}
