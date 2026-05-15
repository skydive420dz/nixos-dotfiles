{ pkgs, ... }:

let
  theme = import ../../theme/tokens.nix;
  palette = theme.palette;
in
{
  systemd.user.services.mako = {
    Unit = {
      Description = "Mako notification daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.mako}/bin/mako";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.configFile."mako/config".text = ''
    font=JetBrainsMono Nerd Font 11
    background-color=${palette.mantle}ee
    text-color=${palette.text}ff
    border-color=${palette.lavender}33
    progress-color=over ${palette.lavender}66
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
