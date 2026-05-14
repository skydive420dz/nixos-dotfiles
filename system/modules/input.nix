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

  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = [ "*" ];

      settings = {
        main = {
          capslock = "overload(controlalt, esc)";
        };

        "controlalt:C-A" = { };
      };
    };
  };
}
