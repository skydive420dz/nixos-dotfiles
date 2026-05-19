{
  config,
  pkgs,
  username,
  homeDirectory,
  ...
}:

{
  home = {
    inherit username homeDirectory;
    stateVersion = "25.05";

    packages = with pkgs; [
      python3
      grimblast
      jq
      wiremix
      kitty
      btop
      nvtopPackages.full
      psmisc
      awww
      libnotify
      mako
      powertop
      (pkgs.writeShellScriptBin "tmux-session" ''
        set -euo pipefail

        tmux_bin="${pkgs.tmux}/bin/tmux"
        fzf_bin="${pkgs.fzf}/bin/fzf"
        home_dir="${config.home.homeDirectory}"
        repo_dir="$home_dir/nixos-dotfiles"
        notes_dir="$home_dir/Documents"

        session_table() {
          printf 'main\t%s\n' "$home_dir"
          printf 'dots\t%s\n' "$repo_dir"
          printf 'quickshell\t%s\n' "$repo_dir"
          printf 'notes\t%s\n' "$notes_dir"
        }

        session_dir() {
          case "$1" in
            main) printf '%s\n' "$home_dir" ;;
            dots|quickshell) printf '%s\n' "$repo_dir" ;;
            notes) printf '%s\n' "$notes_dir" ;;
            *) printf '%s\n' "$PWD" ;;
          esac
        }

        choose_session() {
          if [ -n "''${1:-}" ]; then
            printf '%s\n' "$1"
            return
          fi

          session_table \
            | "$fzf_bin" \
              --delimiter=$'\t' \
              --with-nth=1 \
              --prompt='tmux session > ' \
              --height=40% \
            | cut -f1
        }

        target="$(choose_session "''${1:-}")"
        if [ -z "$target" ]; then
          exit 0
        fi

        dir="$(session_dir "$target")"
        if [ ! -d "$dir" ]; then
          dir="$home_dir"
        fi

        if ! "$tmux_bin" has-session -t "=$target" 2>/dev/null; then
          "$tmux_bin" new-session -d -s "$target" -c "$dir" -n "$target"
        fi

        if [ -n "''${TMUX:-}" ]; then
          exec "$tmux_bin" switch-client -t "=$target"
        fi

        exec "$tmux_bin" attach-session -t "=$target"
      '')
      (pkgs.writeShellScriptBin "hyr" ''
        set -euo pipefail

        # SSH/login shells do not inherit Hyprland's per-session socket env.
        # Resolve it dynamically so remote `hyr reload`/`hyr monitors` still
        # talks to the currently running compositor after each Hyprland restart.
        export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
        hypr_dir="$XDG_RUNTIME_DIR/hypr"

        if [ -z "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
          if [ ! -d "$hypr_dir" ]; then
            printf 'hyr: no Hyprland runtime dir at %s\n' "$hypr_dir" >&2
            exit 1
          fi

          shopt -s nullglob
          instances=("$hypr_dir"/*)
          shopt -u nullglob

          if [ "''${#instances[@]}" -eq 0 ]; then
            printf 'hyr: no Hyprland instance found in %s\n' "$hypr_dir" >&2
            exit 1
          fi

          newest_instance="$(ls -td "''${instances[@]}" | head -n 1)"
          HYPRLAND_INSTANCE_SIGNATURE="''${newest_instance##*/}"

          if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
            printf 'hyr: no Hyprland instance found in %s\n' "$hypr_dir" >&2
            exit 1
          fi

          export HYPRLAND_INSTANCE_SIGNATURE
        fi

        exec hyprctl "$@"
      '')
      (pkgs.writeShellScriptBin "qmlls" ''
        exec ${pkgs.qt6.qtdeclarative}/bin/qmlls \
          -I ${pkgs.qt6.qtdeclarative}/lib/qt-6/qml \
          -I ${pkgs.quickshell}/lib/qt-6/qml \
          -I /etc/profiles/per-user/${config.home.username}/lib/qt-6/qml \
          "$@"
      '')
    ];

    sessionPath = [
      "${config.home.profileDirectory}/bin"
      "$HOME/.config/scripts"
    ];
  };
}
