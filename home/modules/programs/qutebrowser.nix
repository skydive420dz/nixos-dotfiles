{ pkgs, ... }:

let
  tokens = import ../../../theme/tokens.nix;
  s = tokens.semantic;
in
{
  home.packages = with pkgs; [
    qutebrowser
  ];

  xdg.configFile = {
    "qutebrowser/sky_theme_fallback.py".text = ''
      FLAVOR = "${tokens.flavor}"

      def setup(c):
          c.colors.completion.category.bg = "${s.background}"
          c.colors.completion.category.border.bottom = "${s.surface}"
          c.colors.completion.category.border.top = "${s.surface}"
          c.colors.completion.category.fg = "${s.accent}"

          c.colors.completion.even.bg = "${s.background}"
          c.colors.completion.odd.bg = "${s.surface}"
          c.colors.completion.fg = "${s.foreground}"
          c.colors.completion.item.selected.bg = "${s.surfaceStrong}"
          c.colors.completion.item.selected.fg = "${s.foreground}"
          c.colors.completion.match.fg = "${s.warning}"

          c.colors.tabs.even.bg = "${s.surface}"
          c.colors.tabs.odd.bg = "${s.surface}"
          c.colors.tabs.even.fg = "${s.foreground}"
          c.colors.tabs.odd.fg = "${s.foreground}"
          c.colors.tabs.selected.even.bg = "${s.background}"
          c.colors.tabs.selected.odd.bg = "${s.background}"
          c.colors.tabs.selected.even.fg = "${s.accent}"
          c.colors.tabs.selected.odd.fg = "${s.accent}"

          c.colors.statusbar.normal.bg = "${s.background}"
          c.colors.statusbar.normal.fg = "${s.foreground}"
          c.colors.statusbar.insert.bg = "${s.success}"
          c.colors.statusbar.insert.fg = "${s.selectionForeground}"
          c.colors.statusbar.command.bg = "${s.background}"
          c.colors.statusbar.command.fg = "${s.foreground}"
    '';
  };

  xdg.dataFile."qutebrowser/qtwebengine_dictionaries/en-US-145-0.bdic".source =
    pkgs.hunspellDictsChromium.en-us;
}
