{
  config,
  pkgs,
  semantic,
  tmuxCopy,
  tmuxDirName,
}:

''
  # =========================================
  # GENERAL
  # =========================================

  set -ga update-environment " WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP HYPRLAND_INSTANCE_SIGNATURE"

  # =========================================
  # TRUECOLOR
  # =========================================

  set -ga terminal-overrides ",xterm-256color:RGB"

  # =========================================
  # STATUS BAR
  # =========================================

  set -g status-position top
  set -g status-interval 5
  set -g status-style "bg=${semantic.background},fg=${semantic.foreground}"

  set -g status-left-length 100
  set -g status-right-length 100

  set -g status-justify centre
  set -g window-status-separator ""

  set -g window-status-format "\
  #[fg=${semantic.muted},bg=${semantic.background}] #I "

  set -g window-status-current-format "\
  #[fg=${semantic.background},bg=${semantic.accent},bold] \
  #I #[fg=${semantic.accent},bg=${semantic.background}]"

  set -g status-left "\
  #[fg=${semantic.muted},bg=${semantic.surface}] \
   #S #[fg=${semantic.muted},bg=${semantic.background}] \
  #[fg=${semantic.foreground},bg=${semantic.surface}] \
  #(${tmuxDirName} '#{pane_current_path}') \
  #[fg=${semantic.muted},bg=${semantic.background}] "

  set -g status-right "\
  #{prefix_highlight}#[fg=${semantic.muted},bg=${semantic.background}] \
   #{user}   #H "

  # =========================================
  # TMUX UI SURFACES
  # =========================================

  set -g @prefix_highlight_fg '${semantic.background}'
  set -g @prefix_highlight_bg '${semantic.accent}'
  set -g @prefix_highlight_show_copy_mode 'on'
  set -g @prefix_highlight_copy_mode_attr '\
  fg=${semantic.background},bg=${semantic.accentAlt},bold'

  set -g message-style "fg=${semantic.foreground},bg=${semantic.surfaceStrong}"
  set -g message-command-style "fg=${semantic.accent},bg=${semantic.surfaceStrong}"
  set -g mode-style "fg=${semantic.background},bg=${semantic.accent},bold"
  set -g menu-style "fg=${semantic.foreground},bg=${semantic.surface}"
  set -g menu-selected-style "fg=${semantic.background},bg=${semantic.accent},bold"
  set -g menu-border-style "fg=${semantic.borderActive},bg=${semantic.surface}"
  set -g popup-style "fg=${semantic.foreground},bg=${semantic.surface}"
  set -g popup-border-style "fg=${semantic.borderActive},bg=${semantic.surface}"
  run-shell ${pkgs.tmuxPlugins.prefix-highlight.rtp}

  # =========================================
  # PANE BORDERS
  # =========================================

  set -g pane-border-style fg=${semantic.border}
  set -g pane-active-border-style fg=${semantic.borderActive}

  # =========================================
  # SPLITS
  # =========================================

  # Visual/editor naming:
  #   prefix+\ -> vertical split, side-by-side panes (tmux calls this -h)
  #   prefix+| -> horizontal split, stacked panes (tmux calls this -v)
  # Remove tmux defaults that duplicate our chosen split/window keys.
  unbind -q %
  unbind -q '"'
  unbind -q c
  bind \\ split-window -h -c "#{pane_current_path}"
  bind | split-window -v -c "#{pane_current_path}"
  bind Enter new-window -c "#{pane_current_path}"

  # =========================================
  # SESSION ADMIN
  # =========================================

  bind g display-popup -E -w 70% -h 50% "\
  ${config.home.profileDirectory}/bin/tmux-session"
  bind s choose-tree -s -F '\
  #[fg=${semantic.accent},bg=${semantic.background}]\
  #{?session_attached,●,○} #[fg=${semantic.foreground},bg=${semantic.background}]\
  #{session_name} #[fg=${semantic.muted},bg=${semantic.background}]\
  (#{session_windows} windows)'

  # =========================================
  # VIM / TMUX NAVIGATION
  # =========================================

  # Prefer smart-splits' pane-local marker, then fall back to process detection while Neovim starts.
  bind-key -n C-h if-shell "test '#{@pane-is-vim}' = '1' || ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +([^ ]+/)?(g?(view|l?n?vim?x?)(diff)?|mnw|nvim-wrapper)$'" "send-keys C-h" "select-pane -L"
  bind-key -n C-j if-shell "test '#{@pane-is-vim}' = '1' || ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +([^ ]+/)?(g?(view|l?n?vim?x?)(diff)?|mnw|nvim-wrapper)$'" "send-keys C-j" "select-pane -D"
  bind-key -n C-k if-shell "test '#{@pane-is-vim}' = '1' || ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +([^ ]+/)?(g?(view|l?n?vim?x?)(diff)?|mnw|nvim-wrapper)$'" "send-keys C-k" "select-pane -U"
  bind-key -n C-l if-shell "test '#{@pane-is-vim}' = '1' || ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +([^ ]+/)?(g?(view|l?n?vim?x?)(diff)?|mnw|nvim-wrapper)$'" "send-keys C-l" "select-pane -R"

  # =========================================
  # PANE RESIZING
  # =========================================

  bind -r H resize-pane -L 5
  bind -r J resize-pane -D 5
  bind -r K resize-pane -U 5
  bind -r L resize-pane -R 5

  # =========================================
  # COPY MODE
  # =========================================

  # Remove tmux default copy/paste keys; prefix+v and y are our chosen flow.
  unbind-key -q [
  unbind-key -q ]
  bind v copy-mode

  bind-key -T copy-mode-vi Space send-keys -X begin-selection
  bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel '${tmuxCopy}/bin/tmux-copy'
  bind-key -T copy-mode-vi Enter send-keys -X cancel

  # =========================================
  # WINDOW NAMES
  # =========================================

  set -g automatic-rename on
  set -g automatic-rename-format "#{b:pane_current_path}"

  # =========================================
  # RELOAD CONFIG
  # =========================================

  source-file -q ${config.xdg.configHome}/theme/current/tmux.conf
  bind r source-file ${config.xdg.configHome}/tmux/tmux.conf \; display "Reloaded!"
''
