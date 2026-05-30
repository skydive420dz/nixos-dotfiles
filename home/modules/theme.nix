{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    papirus-icon-theme
    libsForQt5.qt5ct
    kdePackages.qt6ct
  ];

  # Nix installs theme support packages; scripts/theme-select owns the live
  # app color state under ~/.config/theme/current.
  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style.name = "fusion";
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  home.activation.applySkyTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    theme_select="$HOME/.config/scripts/theme-select"
    if [ -x "$theme_select" ]; then
      $DRY_RUN_CMD "$theme_select" apply
    fi
  '';
}
