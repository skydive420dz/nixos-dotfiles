{
  config,
  lib,
  repoPath,
  ...
}:

let
  shellAliases = import ./shell-aliases.nix { inherit repoPath; };
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
    };

    inherit shellAliases;

    initContent = lib.mkBefore ''
      if [ -f "$HOME/.openai_key" ]; then
        . "$HOME/.openai_key"
      fi

      if [ -f "$XDG_CONFIG_HOME/theme/current/env" ]; then
        . "$XDG_CONFIG_HOME/theme/current/env"
      elif [ -f "$HOME/.config/theme/current/env" ]; then
        . "$HOME/.config/theme/current/env"
      fi

      current_tty="$(tty 2>/dev/null || true)"

      if [[ -o login ]] \
        && [[ -o interactive ]] \
        && [ -z "$SSH_CONNECTION" ] \
        && [ -z "$WAYLAND_DISPLAY" ] \
        && [ "$current_tty" = "/dev/tty1" ] \
        && uwsm check may-start; then
        exec uwsm start hyprland-uwsm.desktop >/dev/null 2>&1
      fi

      if [[ -o interactive ]] \
        && [ -z "$TMUX" ] \
        && [ -z "$NO_TMUX_AUTO" ] \
        && [ "$TERM" = "xterm-ghostty" ]; then
        tmux-session main
      fi

    '';
  };
}
