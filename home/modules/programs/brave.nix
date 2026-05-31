# ============================================
# BRAVE
# ============================================
# User-level Brave install. Global managed policy lives in
# system/modules/programs/brave.nix so profile state stays browser-owned.

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
  ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
  };
}
