{
  config,
  pkgs,
  username,
  homeDirectory,
  ...
}:

{
  home = {
    inherit username homeDirectory;
    stateVersion = "25.05";

    packages = with pkgs; [
      python3
      grimblast
      jq
      wiremix
      kitty
      btop
      nvtopPackages.full
      yazi
      qutebrowser
      psmisc
      awww
      libnotify
      waybar
      vesktop
      swaynotificationcenter
      swayosd
      powertop
      (pkgs.writeShellScriptBin "qmlls" ''
        exec ${pkgs.qt6.qtlanguageserver}/bin/qmlls \
          -I ${pkgs.qt6.qtdeclarative}/lib/qt-6/qml \
          -I ${pkgs.quickshell}/lib/qt-6/qml \
          -I /etc/profiles/per-user/${config.home.username}/lib/qt-6/qml \
          "$@"
      '')
    ];

    sessionPath = [
      "${config.home.profileDirectory}/bin"
      "$HOME/.config/scripts"
    ];
  };
}
