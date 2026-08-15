{
  hostname,
  lib,
  osConfig,
  ...
}:

let
  hyprctl = "${osConfig.programs.hyprland.package}/bin/hyprctl";
in
{
  config = lib.mkIf (hostname == "nixos") {
    services.hypridle = {
      enable = true;
      settings = {
        general.inhibit_sleep = 0;

        listener = [
          {
            timeout = 600;
            on-timeout = "${hyprctl} dispatch 'hl.dsp.dpms({ action = \"disable\", monitor = \"eDP-1\" })'";
            on-resume = "${hyprctl} dispatch 'hl.dsp.dpms({ action = \"enable\", monitor = \"eDP-1\" })'";
          }
        ];
      };
    };
  };
}
