# ============================================
# DOTFILE LINKS — home-manager
# ============================================
# Three tiers:
#   1. Native home-manager modules → see other home/modules/*.nix
#      (programs.aerc, programs.ghostty, etc.)
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

  liveDirs = {
    ".config/aerc" = "config/aerc";
    ".config/doom" = "config/doom";
    ".config/emacs" = "config/emacs";
    ".config/ghostty/shaders" = "config/ghostty/shaders";
    ".config/quickshell" = "config/quickshell";
    ".config/scripts" = "scripts";
    ".config/sky-nvim" = "config/nvim";
    ".config/wezterm" = "config/wezterm";
  };

  liveFiles = {
    ".config/hypr/hyprland.lua" = "config/hypr/hyprland.lua";
  };

  mkLiveLink = path: {
    source = link path;
  };
in
{
  # ── Tier 2: declarative, copied to Nix store ──────────────────────────────
  # Use `xdg.configFile` instead of `home.file.".config/X"` — it does the
  # same thing but more idiomatically (XDG-aware path).
  #
  # `recursive = true` means each file gets symlinked individually rather
  # than the whole directory — meaning the *directory itself* stays
  # writable, so apps that need to write cache/state into it can do so.
  xdg.configFile = { };

  # ── Tier 3: live-editable, point at the live repo dir ─────────────────────
  # Anything you actively iterate on. Edit the file → it's live.
  # No rebuild needed.
  home.file =
    builtins.mapAttrs (_: mkLiveLink) liveDirs
    // builtins.mapAttrs (_: mkLiveLink) liveFiles
    // {
      ".config/emacs" = (mkLiveLink "config/emacs") // {
        force = true;
      };
    };
}
