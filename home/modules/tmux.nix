{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    # =========================
    # CORE
    # =========================

    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;

    # =========================
    # PLUGINS
    # =========================

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
    ];

    # =========================
    # CONFIG
    # =========================

    extraConfig = ''
      # =========================================
      # GENERAL
      # =========================================

      setw -g pane-base-index 1
      set -g history-limit 100000

      # =========================================
      # KITTY / TRUECOLOR
      # =========================================

      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",xterm-256color:RGB"

      # =========================================
      # STATUS BAR
      # =========================================

      set -g status-position top
      set -g status-interval 5
      set -g status-style "bg=#1e1e2e,fg=#cdd6f4"

      set -g status-left-length 100
      set -g status-right-length 100

      set -g window-status-format ""
      set -g window-status-current-format ""
      set -g window-status-separator ""

      set -g status-left "#[fg=#cba6f7,bg=#1e1e2e]#[fg=#1e1e2e,bg=#cba6f7]  #S #[fg=#cba6f7,bg=#1e1e2e] #[fg=#89b4fa,bg=#1e1e2e]#[fg=#1e1e2e,bg=#89b4fa] 󰉓 #{b:pane_current_path} #[fg=#89b4fa,bg=#1e1e2e]"

      set -g status-right "#[fg=#a6e3a1,bg=#1e1e2e]#[fg=#1e1e2e,bg=#a6e3a1]  #{user} #[fg=#a6e3a1,bg=#1e1e2e] #[fg=#89b4fa,bg=#1e1e2e]#[fg=#1e1e2e,bg=#89b4fa]  #H #[fg=#89b4fa,bg=#1e1e2e] #[fg=#f9e2af,bg=#1e1e2e]#[fg=#1e1e2e,bg=#f9e2af] %H:%M #[fg=#f9e2af,bg=#1e1e2e]"

      # =========================================
      # PANE BORDERS
      # =========================================

      set -g pane-border-style fg=#45475a
      set -g pane-active-border-style fg=#89b4fa

      # =========================================
      # SPLITS
      # =========================================

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # =========================================
      # PANE NAVIGATION
      # =========================================

      bind -r h select-pane -L
      bind -r j select-pane -D
      bind -r k select-pane -U
      bind -r l select-pane -R

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

      bind [ copy-mode

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # =========================================
      # WINDOW NAMES
      # =========================================

      set -g automatic-rename on
      set -g automatic-rename-format "#{b:pane_current_path}"

      # =========================================
      # TMUX RESURRECT / CONTINUUM
      # =========================================

      set -g @resurrect-capture-pane-contents 'on'
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'

      # Save:    Ctrl+a Ctrl+s
      # Restore: Ctrl+a Ctrl+r

      # =========================================
      # RELOAD CONFIG
      # =========================================

      bind r source-file ${config.xdg.configHome}/tmux/tmux.conf \; display "Reloaded!"
    '';
  };
}
