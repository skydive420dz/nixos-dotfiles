{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;

    extraConfig = {
      modi = "run,drun,window";
      icon-theme = "Papirus";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "     Apps ";
      display-run = "     Run ";
      display-window = "     Window ";
      sidebar-mode = true;
    };

    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          # --- PHYSICAL LAYOUT ---
          width = mkLiteral "650px";
          font = "JetBrainsMono Nerd Font Propo 12";

          # --- MOCHA PALETTE ---
          bg-col = mkLiteral "rgba(30, 30, 46, 0.7)";
          bg-col-light = mkLiteral "#1e1e2e";
          border-col = mkLiteral "#b4befe"; # Lavender
          selected-col = mkLiteral "#313244"; # Surface0
          blue = mkLiteral "#89b4fa";
          fg-col = mkLiteral "#cdd6f4";
          fg-col2 = mkLiteral "#f38ba8"; # Red
          grey = mkLiteral "#6c7086";

          # --- INTERNAL RESOLUTION FIXES ---
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg-col";

          active-foreground = mkLiteral "@blue";
          active-background = mkLiteral "@bg-col";
          selected-active-background = mkLiteral "@blue";
          selected-active-foreground = mkLiteral "@bg-col";
          alternate-active-foreground = mkLiteral "@blue";
          alternate-active-background = mkLiteral "@bg-col";

          spacing = 0;
        };

        "window" = {
          height = mkLiteral "500px";
          border = mkLiteral "3px";
          border-radius = mkLiteral "15px";
          border-color = mkLiteral "@border-col";
          background-color = mkLiteral "@bg-col";
        };

        "mainbox" = {
          background-color = mkLiteral "@bg-col";
        };

        "inputbar" = {
          children = mkLiteral "[prompt,entry]";
          background-color = mkLiteral "@bg-col";
          border-radius = mkLiteral "15px";
          padding = mkLiteral "2px";
        };

        "prompt" = {
          background-color = mkLiteral "@blue";
          padding = mkLiteral "6px";
          text-color = mkLiteral "@bg-col";
          border-radius = mkLiteral "15px";
          margin = mkLiteral "20px 0px 0px 20px";
        };

        "entry" = {
          padding = mkLiteral "6px";
          margin = mkLiteral "20px 0px 0px 10px";
          text-color = mkLiteral "@fg-col";
          background-color = mkLiteral "@bg-col";
        };

        "listview" = {
          border = mkLiteral "0px 0px 0px";
          padding = mkLiteral "6px 0px 0px";
          margin = mkLiteral "10px 0px 0px 20px";
          columns = 1;
          lines = 10;
          background-color = mkLiteral "@bg-col";
        };

        "element" = {
          padding = mkLiteral "5px";
          background-color = mkLiteral "@bg-col";
          text-color = mkLiteral "@fg-col";
        };

        "element-icon" = {
          size = mkLiteral "25px";
        };

        "element selected" = {
          background-color = mkLiteral "@selected-col";
          text-color = mkLiteral "@fg-col2";
        };

        "mode-switcher" = {
          spacing = 0;
        };

        "button" = {
          padding = mkLiteral "10px";
          background-color = mkLiteral "@bg-col-light";
          text-color = mkLiteral "@grey";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.5";
        };

        "button selected" = {
          background-color = mkLiteral "@bg-col";
          text-color = mkLiteral "@blue";
        };
      };
  };
}
