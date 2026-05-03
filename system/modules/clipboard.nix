# ============================================
# CLIPBOARD MANAGER — Wayland / Hyprland
# ============================================
# Stack:
#   cliphist        — text + image clipboard history (bbolt DB at
#                     ~/.cache/cliphist/db, last ~750 entries by default)
#   wl-clip-persist — keep clipboard contents alive after source app closes
#                     (vanilla Wayland drops the clipboard when the owner exits)
#   wl-clipboard    — provides wl-copy / wl-paste, used by cliphist + scripts
#   rofi            — picker UI (already in your stack)
#
# Hyprland keybinds (add to hyprland.conf, see bottom of this file):
#   SUPER + X         → pick from history, paste it
#   SUPER + SHIFT + X → pick an entry to delete
#
# Hyprland exec-once entries (also at the bottom): the wl-paste watchers
# and wl-clip-persist must run inside the Hyprland session — they cannot
# be NixOS systemd services because they need WAYLAND_DISPLAY.
#
# Privacy:
#   Password managers that set the standard "x-kde-passwordManagerHint:
#   secret" MIME hint are skipped automatically by cliphist. Bitwarden
#   and KeePassXC do this by default. 1Password's Linux app currently
#   does NOT — for that, use `cliphist wipe` after copying secrets, or
#   bind a key to it.

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cliphist # history daemon + CLI
    wl-clip-persist # keep clipboard alive after app close
    wl-clipboard # wl-copy / wl-paste
  ];

  # Optional: a small wrapper script for "wipe history".
  # Useful to bind to a panic-clear keybind, or run periodically.
  environment.etc."skel/.local/bin/cliphist-wipe".text = ''
    #!/usr/bin/env bash
    cliphist wipe
    notify-send "Clipboard history cleared" -i edit-clear -t 1500
  '';
}

# ============================================
# HYPRLAND INTEGRATION
# ============================================
# Add the following to your hyprland.conf. They are NOT set by this Nix
# module because they belong to the Hyprland config, not system config.
#
# ── Auto-start (top of hyprland.conf, alongside other exec-once lines) ──────
#
#   # Watch clipboard for text and images, store in cliphist DB
#   exec-once = wl-paste --type text  --watch cliphist store
#   exec-once = wl-paste --type image --watch cliphist store
#
#   # Keep clipboard contents alive after source app exits
#   exec-once = wl-clip-persist --clipboard regular
#
# ── Keybinds (in your KEYBINDINGS section) ──────────────────────────────────
#
#   # Pick from history → paste
#   bind = $mainMod, X,        exec, cliphist list | rofi -dmenu -p "Clipboard" | cliphist decode | wl-copy
#
#   # Pick an entry to delete from history
#   bind = $mainMod SHIFT, X,  exec, cliphist list | rofi -dmenu -p "Delete"    | cliphist delete
#
#   # Optional: wipe entire history (panic clear)
#   bind = $mainMod CTRL, X,   exec, cliphist wipe && notify-send "Clipboard cleared"
#
# ── Workflow ────────────────────────────────────────────────────────────────
#
#   1. Copy normally (Ctrl+C anywhere)
#   2. Press Super+X to open the picker
#   3. Fuzzy-search, hit Enter
#   4. The selected entry is now on the clipboard — paste with Ctrl+V
#
# ============================================
