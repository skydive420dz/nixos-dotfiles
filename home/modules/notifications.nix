{ pkgs, ... }:

let
  theme = import ../../theme/tokens.nix;
  semantic = theme.semantic;
in
{
  systemd.user.services.mako = {
    Unit = {
      Description = "Mako notification daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStartPre = "${pkgs.bash}/bin/bash %h/.config/scripts/theme-select apply";
      ExecStart = "${pkgs.mako}/bin/mako -c %h/.config/theme/current/mako.conf";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.configFile."mako/config".text = ''
    # Generated runtime theme lives in ~/.config/theme/current/mako.conf.
    # This fallback keeps mako usable before the first theme-select apply.
    font=JetBrainsMono Nerd Font 11
    background-color=${semantic.surface}ee
    text-color=${semantic.foreground}ff
    border-color=${semantic.accent}33
    progress-color=over ${semantic.accent}66
    width=360
    height=110
    margin=16
    padding=12
    border-size=1
    border-radius=10
    default-timeout=5000
    anchor=top-right
  '';
}
