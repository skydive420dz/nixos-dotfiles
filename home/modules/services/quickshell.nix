{ pkgs, ... }:

let
  quickshell = "${pkgs.quickshell}/bin/quickshell";

  mkQuickshellService =
    {
      description,
      path,
    }:
    {
      Unit = {
        Description = description;
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${quickshell} -p ${path}";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
in
{
  systemd.user.services = {
    quickshell = mkQuickshellService {
      description = "Quickshell bar";
      path = "%h/.config/quickshell";
    };

    quickshell-launcher = mkQuickshellService {
      description = "Quickshell launcher";
      path = "%h/.config/quickshell/launcher";
    };

    quickshell-clipboard = mkQuickshellService {
      description = "Quickshell clipboard";
      path = "%h/.config/quickshell/clipboard";
    };

    quickshell-osd = mkQuickshellService {
      description = "Quickshell OSD";
      path = "%h/.config/quickshell/osd";
    };
  };
}
