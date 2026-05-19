{ pkgs, ... }:

let
  tokens = import ../../../theme/tokens.nix;
  p = tokens.palette;
in
{
  home.packages = with pkgs; [
    qutebrowser
  ];

  xdg.configFile = {
    "qutebrowser/catppuccin.py".text = ''
      def setup(c, flavor="mocha", statusbar_bold=False):
          palette = {
              "rosewater": "${p.rosewater}",
              "flamingo": "${p.flamingo}",
              "pink": "${p.pink}",
              "mauve": "${p.mauve}",
              "red": "${p.red}",
              "maroon": "${p.maroon}",
              "peach": "${p.peach}",
              "yellow": "${p.yellow}",
              "green": "${p.green}",
              "teal": "${p.teal}",
              "sky": "${p.sky}",
              "sapphire": "${p.sapphire}",
              "blue": "${p.blue}",
              "lavender": "${p.lavender}",
              "text": "${p.text}",
              "subtext1": "${p.subtext1}",
              "subtext0": "${p.subtext0}",
              "overlay2": "${p.overlay2}",
              "overlay1": "${p.overlay1}",
              "overlay0": "${p.overlay0}",
              "surface2": "${p.surface2}",
              "surface1": "${p.surface1}",
              "surface0": "${p.surface0}",
              "base": "${p.base}",
              "mantle": "${p.mantle}",
              "crust": "${p.crust}",
          }

          c.colors.completion.category.bg = palette["base"]
          c.colors.completion.category.border.bottom = palette["mantle"]
          c.colors.completion.category.border.top = palette["mantle"]
          c.colors.completion.category.fg = palette["lavender"]

          c.colors.tabs.even.bg = palette["surface0"]
          c.colors.tabs.odd.bg = palette["surface0"]
          c.colors.tabs.selected.even.bg = palette["base"]
          c.colors.tabs.selected.odd.bg = palette["base"]
          c.colors.tabs.selected.even.fg = palette["mauve"]
          c.colors.tabs.selected.odd.fg = palette["mauve"]

          c.colors.statusbar.normal.bg = palette["base"]
          c.colors.statusbar.insert.bg = palette["green"]
    '';
  };

  xdg.dataFile."qutebrowser/qtwebengine_dictionaries/en-US-145-0.bdic".source =
    pkgs.hunspellDictsChromium.en-us;
}
