# ============================================
# DOTFILE LINKS — home-manager
# ============================================
# Three tiers:
#   1. Native home-manager modules → see other home/modules/*.nix
#      (programs.aerc, programs.kitty, programs.qutebrowser, etc.)
#   2. xdg.configFile (Nix store, declarative)
#      Used for stable configs that don't change often. Read-only.
#      Editing requires rebuild but is fully reproducible.
#   3. mkOutOfStoreSymlink (live edits, no rebuild)
#      For files you tweak constantly — keybinds, themes-in-progress,
#      anything where the rebuild loop slows you down.

{ config, repoPath, ... }:

let
  # Repo root path. Defined once so renames are a one-line change.
  repoRoot = repoPath;

  # Helper for live-editable links.
  link = path: config.lib.file.mkOutOfStoreSymlink "${repoRoot}/${path}";
in
{
  # ── Tier 2: declarative, copied to Nix store ──────────────────────────────
  # Use `xdg.configFile` instead of `home.file.".config/X"` — it does the
  # same thing but more idiomatically (XDG-aware path).
  #
  # `recursive = true` means each file gets symlinked individually rather
  # than the whole directory — meaning the *directory itself* stays
  # writable, so apps that need to write cache/state into it can do so.
  xdg.configFile = {
    "swaync/config.json".source = ../../config/swaync/config.json;
    "swaync/style.css".source = ../../config/swaync/style.css;
    "hypr/mocha.conf".source = ../../config/hypr/mocha.conf;
    "waybar/mocha.css".source = ../../config/waybar/mocha.css;
    "swayosd".source = ../../config/swayosd;
  };

  # ── Tier 3: live-editable, point at the live repo dir ─────────────────────
  # Anything you actively iterate on. Edit the file → it's live.
  # No rebuild needed.
  home.file = {
    ".config/quickshell".source = link "config/quickshell";
    ".config/yazi".source = link "config/yazi";
    ".config/aerc".source = link "config/aerc";
    ".config/scripts".source = link "scripts";
  };
}
