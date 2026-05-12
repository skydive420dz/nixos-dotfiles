{ pkgs, ... }:

{
  services.dbus = {
    implementation = "broker";
    packages = [ pkgs.swayosd ];
  };

  services.udev.packages = [ pkgs.swayosd ];

  systemd.services.swayosd-libinput-backend = {
    description = "SwayOSD Libinput Backend";
    after = [
      "udev.service"
      "multi-user.target"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
      Restart = "on-failure";
      RestartSec = "3s";
    };
  };

  services.libinput.enable = true;
}
