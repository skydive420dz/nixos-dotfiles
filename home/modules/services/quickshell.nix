{ lib, pkgs, ... }:

{
  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell bar";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Environment = [
        "SKY_FFMPEG=${lib.getExe pkgs.ffmpeg}"
        "QT_DISABLE_HW_TEXTURES_CONVERSION=1"
        "QML2_IMPORT_PATH=${lib.makeSearchPath "lib/qt-6/qml" [
          pkgs.qt6.qtdeclarative
          pkgs.qt6.qtmultimedia
          pkgs.quickshell
        ]}"
        "QT_PLUGIN_PATH=${lib.makeSearchPath "lib/qt-6/plugins" [
          pkgs.qt6.qtbase
          pkgs.qt6.qtimageformats
          pkgs.qt6.qtmultimedia
          pkgs.quickshell
        ]}"
      ];
      ExecStartPre = "${pkgs.bash}/bin/bash %h/.config/scripts/theme-select apply";
      ExecStart = "${pkgs.quickshell}/bin/quickshell -p %h/.config/quickshell";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
