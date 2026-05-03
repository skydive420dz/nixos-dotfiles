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
          width = mkLiteral "650px";
          font = "JetBrainsMono Nerd Font Propo 12";

          bg-col = mkLiteral "rgba(30, 30, 46, 0.2)";
          bg-col-light = mkLiteral "rgba(49, 50, 68, 0.4)";
          border-col = mkLiteral "rgba(180, 190, 254, 0.3)";
          selected-col = mkLiteral "rgba(49, 50, 68, 0.5)";
          blue = mkLiteral "rgba(137, 180, 250, 0.6)";
          fg-col = mkLiteral "#cdd6f4";
          fg-col2 = mkLiteral "#f38ba8";
          grey = mkLiteral "#6c7086";

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
          border = mkLiteral "2px";
          border-radius = mkLiteral "15px";
          border-color = mkLiteral "@border-col";
          background-color = mkLiteral "@bg-col";
        };

        "mainbox" = {
          background-color = mkLiteral "transparent";
        };

        "inputbar" = {
          children = mkLiteral "[prompt,entry]";
          background-color = mkLiteral "transparent";
          border-radius = mkLiteral "15px";
          padding = mkLiteral "2px";
        };

        "prompt" = {
          background-color = mkLiteral "@blue";
          padding = mkLiteral "6px";
          text-color = mkLiteral "#1e1e2e";
          border-radius = mkLiteral "15px";
          margin = mkLiteral "20px 0px 0px 20px";
        };

        "entry" = {
          padding = mkLiteral "6px";
          margin = mkLiteral "20px 0px 0px 10px";
          text-color = mkLiteral "@fg-col";
          background-color = mkLiteral "transparent";
        };

        "listview" = {
          border = mkLiteral "0px 0px 0px";
          padding = mkLiteral "6px 0px 0px";
          margin = mkLiteral "10px 0px 0px 20px";
          columns = 1;
          lines = 10;
          background-color = mkLiteral "transparent";
        };

        "element" = {
          padding = mkLiteral "5px";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg-col";
        };

        "element-icon" = {
          size = mkLiteral "25px";
        };

        "element selected" = {
          background-color = mkLiteral "@selected-col";
          text-color = mkLiteral "@fg-col2";
          border-radius = mkLiteral "8px";
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
          background-color = mkLiteral "@blue";
          text-color = mkLiteral "#1e1e2e";
        };
      };
  };
}
