{ config, pkgs, ... }:

let
  tokens = import ../../config/theme/tokens.nix;
  palette = tokens.palette;
  semantic = tokens.semantic;
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;

    extraConfig = {
      modi = "combi,drun,run,window";
      combi-modi = "drun,run,window";
      icon-theme = "Papirus";
      show-icons = true;
      drun-display-format = "{name}";
      location = 0;
      matching = "fuzzy";
      sort = true;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "";
      display-run = "";
      display-window = "󰖲";
      display-combi = "";
      sidebar-mode = false;
    };

    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
        transparent = color: alpha: mkLiteral "${color}${alpha}";
      in
      {
        "*" = {
          width = mkLiteral "680px";
          font = "JetBrainsMono Nerd Font Propo 13";

          bg-col = transparent palette.base "d9";
          bg-col-light = transparent palette.surface0 "a8";
          border-col = transparent semantic.accent "33";
          selected-col = transparent palette.surface1 "bd";
          input-col = transparent palette.mantle "e6";
          accent-col = transparent semantic.borderActive "dc";
          fg-col = mkLiteral semantic.foreground;
          fg-col2 = mkLiteral palette.subtext1;
          muted-col = mkLiteral semantic.muted;

          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg-col";

          active-foreground = mkLiteral "@accent-col";
          active-background = mkLiteral "@bg-col";
          selected-active-background = mkLiteral "@accent-col";
          selected-active-foreground = mkLiteral "@bg-col";
          alternate-active-foreground = mkLiteral "@accent-col";
          alternate-active-background = mkLiteral "@bg-col";

          spacing = 0;
        };

        "window" = {
          height = mkLiteral "360px";
          border = mkLiteral "1px";
          border-radius = mkLiteral "20px";
          border-color = mkLiteral "@border-col";
          background-color = mkLiteral "@bg-col";
        };

        "mainbox" = {
          background-color = mkLiteral "transparent";
          padding = mkLiteral "16px";
          spacing = mkLiteral "10px";
        };

        "inputbar" = {
          children = mkLiteral "[prompt,entry]";
          background-color = mkLiteral "@input-col";
          border = mkLiteral "1px";
          border-radius = mkLiteral "15px";
          border-color = mkLiteral "@border-col";
          padding = mkLiteral "12px 15px";
          spacing = mkLiteral "11px";
        };

        "prompt" = {
          background-color = mkLiteral "transparent";
          padding = mkLiteral "0px 2px 0px 0px";
          text-color = mkLiteral "@accent-col";
          border-radius = mkLiteral "0px";
          margin = mkLiteral "0px";
        };

        "entry" = {
          padding = mkLiteral "0px";
          margin = mkLiteral "0px";
          text-color = mkLiteral "@fg-col";
          background-color = mkLiteral "transparent";
        };

        "listview" = {
          border = mkLiteral "0px 0px 0px";
          padding = mkLiteral "0px";
          margin = mkLiteral "0px";
          columns = 1;
          lines = 6;
          spacing = mkLiteral "3px";
          background-color = mkLiteral "transparent";
        };

        "element" = {
          padding = mkLiteral "8px 11px";
          border-radius = mkLiteral "11px";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg-col";
        };

        "element-icon" = {
          size = mkLiteral "24px";
          margin = mkLiteral "0px 12px 0px 0px";
        };

        "element selected" = {
          background-color = mkLiteral "@selected-col";
          text-color = mkLiteral "@fg-col";
        };

        "element selected element-icon" = {
          text-color = mkLiteral "@accent-col";
        };

        "mode-switcher" = {
          spacing = 0;
        };

        "button" = {
          padding = mkLiteral "8px";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@muted-col";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.5";
        };

        "button selected" = {
          background-color = mkLiteral "@bg-col-light";
          text-color = mkLiteral "@fg-col";
        };
      };
  };
}
