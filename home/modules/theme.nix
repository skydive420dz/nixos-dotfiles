{ pkgs, ... }:

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
    platformTheme.name = "qt6ct";
    style.name = "Fusion";
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  systemd.user.services.sky-theme-apply = {
    Unit = {
      Description = "Generate Sky runtime theme";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash %h/.config/scripts/theme-select apply";
      RemainAfterExit = true;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
