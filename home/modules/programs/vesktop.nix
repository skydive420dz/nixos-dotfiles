{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.vesktop ];

  xdg.configFile."autostart/vesktop.desktop" = {
    force = true;
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Vesktop
      Hidden=true
      NoDisplay=true
    '';
  };

  home.activation.removeVesktopAutostartBackup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    rm -f "$HOME/.config/autostart/vesktop.desktop.backup"
  '';
}
