{ pkgs, ... }:

{
  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell bar";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStartPre = "${pkgs.bash}/bin/bash %h/.config/scripts/theme-select apply";
      ExecStart = "${pkgs.quickshell}/bin/quickshell -p %h/.config/quickshell";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
