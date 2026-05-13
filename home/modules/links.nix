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
  theme = import ../../config/theme/tokens.nix;
  colors = theme.palette;
  semantic = theme.semantic;
  terminal = theme.terminal;

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
    "swayosd".source = ../../config/swayosd;
    "rofi".source = ../../config/rofi;
    "kitty/theme".text = ''
      # vim:ft=kitty
      # Generated from config/theme/tokens.nix (${theme.name})

      foreground              ${semantic.foreground}
      background              ${semantic.background}
      selection_foreground    ${semantic.selectionForeground}
      selection_background    ${semantic.selectionBackground}

      cursor                  ${colors.rosewater}
      cursor_text_color       ${semantic.selectionForeground}
      url_color               ${colors.rosewater}

      active_border_color     ${semantic.accent}
      inactive_border_color   ${semantic.muted}
      bell_border_color       ${semantic.warning}

      wayland_titlebar_color  system
      active_tab_foreground   ${colors.crust}
      active_tab_background   ${semantic.accentAlt}
      inactive_tab_foreground ${semantic.foreground}
      inactive_tab_background ${colors.mantle}
      tab_bar_background      ${colors.crust}

      color0  ${terminal.black}
      color8  ${terminal.brightBlack}
      color1  ${terminal.red}
      color9  ${terminal.brightRed}
      color2  ${terminal.green}
      color10 ${terminal.brightGreen}
      color3  ${terminal.yellow}
      color11 ${terminal.brightYellow}
      color4  ${terminal.blue}
      color12 ${terminal.brightBlue}
      color5  ${terminal.magenta}
      color13 ${terminal.brightMagenta}
      color6  ${terminal.cyan}
      color14 ${terminal.brightCyan}
      color7  ${terminal.white}
      color15 ${terminal.brightWhite}
    '';
  };

  # ── Tier 3: live-editable, point at the live repo dir ─────────────────────
  # Anything you actively iterate on. Edit the file → it's live.
  # No rebuild needed.
  home.file = {
    ".config/kitty/kitty.conf".source = link "config/kitty/kitty.conf";
    ".config/kitty/sessions".source = link "config/kitty/sessions";
    ".config/kitty/tab-styles.py".source = link "config/kitty/tab-styles.py";
    ".config/quickshell".source = link "config/quickshell";
    ".config/yazi".source = link "config/yazi";
    ".config/qutebrowser".source = link "config/qutebrowser";
    ".config/aerc".source = link "config/aerc";
    ".config/scripts".source = link "scripts";
  };
}
