{
  config,
  pkgs,
  username,
  homeDirectory,
  ...
}:

{
  home.enableNixpkgsReleaseCheck = false;

  home = {
    inherit username homeDirectory;
    stateVersion = "25.05";

    packages = with pkgs; [
      python3
      grimblast
      jq
      wiremix
      btop
      nvtopPackages.full
      psmisc
      libnotify
      mako
      powertop
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
