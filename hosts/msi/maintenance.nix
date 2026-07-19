{ lib, ... }:

{
  nix.gc = {
    automatic = true;
    dates = "Sun *-*-* 04:15:00";
    options = "--delete-older-than 30d";
    persistent = false;
    randomizedDelaySec = "45min";
  };

  # Keep the reviewed timer installed but unarmed until the first GC is
  # separately authorized and observed.
  systemd.timers.nix-gc.wantedBy = lib.mkForce [ ];
}
