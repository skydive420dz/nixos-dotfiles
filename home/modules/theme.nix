{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Icons: We only use the catppuccin version to avoid the "conflicting subpath" error
    (catppuccin-papirus-folders.override { flavor = "mocha"; })

    # Theme engine and configuration tools
    libsForQt5.qt5ct
    kdePackages.qt6ct
    libsForQt5.qtstyleplugin-kvantum
    (catppuccin-kvantum.override {
      variant = "mocha";
      accent = "lavender";
    })
  ];

  # --- GTK CONFIGURATION ---
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-lavender-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "lavender" ];
        variant = "mocha";
      };
    };

    iconTheme = {
      name = "Papirus-Dark";
    };

    cursorTheme = {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
    };

    gtk4.theme = config.gtk.theme;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  # --- QT CONFIGURATION ---
  qt = {
    enable = true;
    platformTheme.name = "qt5ct"; # Fixed: matches HM's expected value
    style.name = "kvantum";
  };

  # This configures Kvantum to use Mocha automatically
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Catppuccin-Mocha-Lavender
  '';

  # --- CURSOR FIX ---
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.catppuccin-cursors.mochaDark;
    name = "catppuccin-mocha-dark-cursors";
    size = 24;
  };
}
