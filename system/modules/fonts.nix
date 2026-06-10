# ============================================
# FONTS
# ============================================
# Strategy:
#   1. A few primary Nerd Fonts for terminal use (already had these).
#   2. nerd-fonts.symbols-only — a single font that contains EVERY Nerd
#      Font icon (Material Design, FontAwesome, Devicons, Octicons,
#      Powerline, Codicons, Weather, Pomicons, IEC). Used as a fallback
#      so missing glyphs in one font are filled in from another.
#   3. Emoji + CJK + general Unicode coverage for everything else.
#   4. fontconfig defaults that prefer the symbols-only font for icon
#      glyphs without overriding text in Nerd Fonts.
#
# After applying:
#   sudo fc-cache -fv
#   pkill ghostty   # restart Ghostty to pick up new font cache

{ pkgs, ... }:

{
  fonts = {
    # All fonts we want available system-wide.
    packages = with pkgs; [
      # ── Primary monospace Nerd Fonts (terminal / editor) ────────────────
      nerd-fonts.jetbrains-mono
      nerd-fonts.commit-mono
      nerd-fonts.fantasque-sans-mono

      # ── Universal Nerd Font symbols (icon fallback) ─────────────────────
      # This package provides "Symbols Nerd Font" / "Symbols Nerd Font Mono"
      # which is JUST the icon glyphs from EVERY Nerd Font set. Use it as
      # a fontconfig fallback so any icon in any range renders even if
      # your primary font is missing it.
      nerd-fonts.symbols-only
      emacs-all-the-icons-fonts

      # ── Plain text fonts ────────────────────────────────────────────────
      font-awesome # explicit FontAwesome (some apps look for it by name)
      noto-fonts # broad Unicode coverage
      noto-fonts-cjk-sans # CJK sans
      noto-fonts-color-emoji
      symbola # Doom Emacs fallback font for broad Unicode symbols
      liberation_ttf # MS-compatible (Arial/Times/Courier replacements)
      dejavu_fonts # widely-used, good fallback
      inter # the Inter UI font
      source-serif # serif option
    ];

    # Enable fontconfig and its default settings.
    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      subpixel.rgba = "rgb";

      # Default font preferences. fontconfig picks the first available
      # font from each list when a generic family is requested.
      defaultFonts = {
        monospace = [
          "JetBrainsMono Nerd Font Mono"
          "Symbols Nerd Font Mono" # icon fallback
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Inter"
          "Noto Sans"
          "Symbols Nerd Font"
          "Noto Color Emoji"
        ];
        serif = [
          "Source Serif"
          "Noto Serif"
          "Symbols Nerd Font"
          "Noto Color Emoji"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };

    # Don't include the (very large) font cache snapshot in the closure.
    # Disable this if you're on a system without internet for boot.
    fontDir.enable = true;
  };
}
