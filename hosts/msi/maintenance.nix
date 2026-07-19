{
  nix.gc = {
    automatic = true;
    dates = "Sun *-*-* 04:15:00";
    options = "--delete-older-than 30d";
    persistent = false;
    randomizedDelaySec = "45min";
  };
}
