{ ... }:

let
  theme = import ../../theme/tokens.nix;
  colors = theme.palette;
  semantic = theme.semantic;
  terminal = theme.terminal;
in
{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12.0;
    };

    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      confirm_os_window_close = 0;
      background_opacity = "0.85";
      window_padding_width = 10;
      scrollback_lines = 10000;
      enable_audio_bell = "no";
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      tab_bar_edge = "top";
      tab_title_template = "{index} {title}";
      cursor_trail = 10;

      fps_limit = 144;
      input_delay = 3;
      cursor_blink_interval = 0;
      repaint_delay = 10;

      wheel_scroll_multiplier = "5.0";
      touch_scroll_multiplier = "5.0";
      mouse_hide_wait = "3.0";

      shell_integration = "enabled";
      allow_remote_control = "yes";
      title = "Terminal";

      foreground = semantic.foreground;
      background = semantic.background;
      selection_foreground = semantic.selectionForeground;
      selection_background = semantic.selectionBackground;

      cursor = colors.rosewater;
      cursor_text_color = semantic.selectionForeground;
      url_color = colors.rosewater;

      active_border_color = semantic.accent;
      inactive_border_color = semantic.muted;
      bell_border_color = semantic.warning;

      wayland_titlebar_color = "system";
      active_tab_foreground = colors.crust;
      active_tab_background = semantic.accentAlt;
      inactive_tab_foreground = semantic.foreground;
      inactive_tab_background = colors.mantle;
      tab_bar_background = colors.crust;

      color0 = terminal.black;
      color8 = terminal.brightBlack;
      color1 = terminal.red;
      color9 = terminal.brightRed;
      color2 = terminal.green;
      color10 = terminal.brightGreen;
      color3 = terminal.yellow;
      color11 = terminal.brightYellow;
      color4 = terminal.blue;
      color12 = terminal.brightBlue;
      color5 = terminal.magenta;
      color13 = terminal.brightMagenta;
      color6 = terminal.cyan;
      color14 = terminal.brightCyan;
      color7 = terminal.white;
      color15 = terminal.brightWhite;
    };

    keybindings = {
      "alt+enter" = "new_window";
      "alt+w" = "close_window";
      "alt+]" = "next_window";
      "alt+[" = "previous_window";
      "alt+right" = "next_tab";
      "alt+left" = "previous_tab";
      "alt+e" = "open_url_with_hints";
      "alt+y" = "kitten hints --type word --program @";
      "alt+p" = "kitten hints --type path --program @";
      "alt+n" = "kitten hints --type path --program nvim";
      "alt+c" = "copy_to_clipboard";
      "alt+v" = "paste_from_clipboard";
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";
    };
  };

}
