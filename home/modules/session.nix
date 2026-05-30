{
  homeDirectory,
  lib,
  pkgs,
  ...
}:

{
  home.sessionVariables = {
    SKY_THEME = "SkyDark";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
    GTK_THEME = "Adwaita";
    GTK2_RC_FILES = "${homeDirectory}/.config/gtk-2.0/gtkrc";
    QT_STYLE_OVERRIDE = "Fusion";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QML2_IMPORT_PATH = lib.makeSearchPath "lib/qt-6/qml" [
      pkgs.qt6.qtdeclarative
      pkgs.quickshell
    ];
    QT_PLUGIN_PATH = lib.makeSearchPath "lib/qt-6/plugins" [
      pkgs.qt6.qtbase
      pkgs.quickshell
    ];

    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    AQ_DRM_DEVICES = "/dev/dri/card0:/dev/dri/card1";
    NVD_BACKEND = "direct";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };
}
