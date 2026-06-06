{
  config,
  lib,
  repoPath,
  ...
}:

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

    shellAliases = {
      btw = "echo I use nixos, btw";
      ncg = "sudo nix-collect-garbage -d";
      nfu = "nix flake update --flake ${repoPath}";
      nrb = "sudo nixos-rebuild boot --impure --flake ${repoPath}#nixos";
      nrs = "sudo nixos-rebuild switch --impure --flake ${repoPath}#nixos";
      vim = "nvim";
      ls = "ls --color=auto";
      cat = "bat";
      btop = "ghostty --title=btop_float -e btop";
      nvtop = "ghostty --title=nvtop_float -e nvtop";
      tm = "tmux-session main";
      tmd = "tmux-session dots";
      discord = "vesktop --use-gl=desktop --enable-features=UseOzonePlatform --ozone-platform=wayland";
    };

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
