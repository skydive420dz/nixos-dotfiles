{ lib, pkgs, ... }:

{
  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell desktop shell";
      Wants = [ "sky-theme-apply.service" ];
      After = [
        "graphical-session.target"
        "sky-theme-apply.service"
      ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Environment = [
        "SKY_FFMPEG=${lib.getExe pkgs.ffmpeg}"
        "QT_DISABLE_HW_TEXTURES_CONVERSION=1"
        "QML2_IMPORT_PATH=${
          lib.makeSearchPath "lib/qt-6/qml" [
            pkgs.qt6.qtdeclarative
            pkgs.qt6.qtmultimedia
            pkgs.quickshell
          ]
        }"
        "QT_PLUGIN_PATH=${
          lib.makeSearchPath "lib/qt-6/plugins" [
            pkgs.qt6.qtbase
            pkgs.qt6.qtimageformats
            pkgs.qt6.qtmultimedia
            pkgs.quickshell
          ]
        }"
      ];
      ExecStart = "${pkgs.quickshell}/bin/quickshell -p %h/.config/quickshell";
      Restart = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
