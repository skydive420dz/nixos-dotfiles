{ pkgs, ... }:

{
  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell bar";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.quickshell}/bin/quickshell -p %h/.config/quickshell";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
