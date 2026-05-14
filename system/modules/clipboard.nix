# ============================================
# CLIPBOARD MANAGER — Wayland / Hyprland
# ============================================
# Stack:
#   cliphist        — text + image clipboard history (bbolt DB at
#                     ~/.cache/cliphist/db, last ~750 entries by default)
#   wl-clip-persist — keep clipboard contents alive after source app closes
#   wl-clipboard    — provides wl-copy / wl-paste, used by cliphist + scripts
#   cliphist-wipe   — small wrapper: clears history + shows a toast notification
#
# Hyprland integration (must live in hyprland.conf — needs $WAYLAND_DISPLAY):
#
#   exec-once = wl-paste --type text  --watch cliphist store
#   exec-once = wl-paste --type image --watch cliphist store
#   exec-once = wl-clip-persist --clipboard regular
#
#   Caps+Y and Caps+P are emitted by keyd as Ctrl+C and Ctrl+V.
#
# Privacy:
#   Password managers that set "x-kde-passwordManagerHint: secret" MIME hint
#   are skipped automatically. Bitwarden + KeePassXC do this by default;
#   1Password Linux currently does not — bind cliphist-wipe to a panic key.

{ pkgs, ... }:

let
  # Wrapper script: clear history + notify.
  # writeShellScriptBin creates a proper executable in the Nix store,
  # automatically chmod +x, automatically on PATH.
  cliphist-wipe = pkgs.writeShellScriptBin "cliphist-wipe" ''
    ${pkgs.cliphist}/bin/cliphist wipe
    ${pkgs.libnotify}/bin/notify-send "Clipboard history cleared" \
      -i edit-clear -t 1500
  '';
in
{
  environment.systemPackages = with pkgs; [
    cliphist
    wl-clip-persist
    wl-clipboard
    cliphist-wipe
  ];
}
