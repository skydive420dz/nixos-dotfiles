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
      nrs = "sudo nixos-rebuild switch --impure --flake ${repoPath}#nixos";
      ncheck = "nix eval --no-write-lock-file ${repoPath}#nixosConfigurations.nixos-check.config.system.build.toplevel.drvPath";
      vim = "nvim";
      ls = "ls --color=auto";
      cat = "bat";
      btop = "kitty --title btop_float -e btop";
      nvtop = "kitty --title nvtop_float -e nvtop";
      tm = "tmux new -A -s main";
      tmd = "tmux new -A -s dots";
      discord = "vesktop --use-gl=desktop --enable-features=UseOzonePlatform --ozone-platform=wayland";
    };

    initContent = lib.mkBefore ''
      if [ -f "$HOME/.openai_key" ]; then
        . "$HOME/.openai_key"
      fi

      if uwsm check may-start; then
        exec uwsm start hyprland-uwsm.desktop > /dev/null 2>&1
      fi

      if [[ -o interactive ]] \
        && [ -z "$TMUX" ] \
        && [ -z "$NO_TMUX_AUTO" ] \
        && { [ "$TERM" = "xterm-kitty" ] || [ -n "$KITTY_WINDOW_ID" ]; }; then
        tmux new -A -s main
      fi

      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }
    '';
  };
}
