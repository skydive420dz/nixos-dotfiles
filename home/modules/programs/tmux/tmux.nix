{ config, lib, pkgs, ... }:

let
  theme = import ../../../../theme/tokens.nix;
  semantic = theme.semantic;

  tmuxCopy = pkgs.writeShellScriptBin "tmux-copy" (
    if pkgs.stdenv.isDarwin then
      ''
        exec /usr/bin/pbcopy
      ''
    else
      ''
        if [ -n "''${WAYLAND_DISPLAY:-}" ]; then
          exec ${lib.getExe' pkgs.wl-clipboard "wl-copy"}
        fi

        if [ -n "''${DISPLAY:-}" ]; then
          exec ${lib.getExe pkgs.xclip} -selection clipboard
        fi

        printf 'tmux-copy: no supported clipboard backend found\n' >&2
        exit 1
      ''
  );

  tmuxDirName = pkgs.writeShellScript "tmux-dir-name" ''
    path="''${1:-$PWD}"
    name="''${path##*/}"

    case "$path" in
      "$HOME") printf ' ~' ;;
      /) printf '/' ;;
      *)
        case "$name" in
          Documents) printf '󰈙' ;;
          Downloads) printf '' ;;
          Music) printf '󰝚' ;;
          Pictures) printf '' ;;
          Videos) printf '󰕧' ;;
          nixos-dotfiles) printf '' ;;
          *) printf '󰉓 %s' "$name" ;;
        esac
        ;;
    esac
  '';

  extraConfig = import ./extra-config.nix {
    inherit config pkgs semantic tmuxCopy tmuxDirName;
  };
in
{
  home.packages = [ tmuxCopy ];

  programs.tmux = {
    enable = true;

    # =========================
    # CORE
    # =========================

    prefix = "C-Space";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 100000;
    keyMode = "vi";
    mouse = true;
    sensibleOnTop = true;
    terminal = "tmux-direct";

    # =========================
    # PLUGINS
    # =========================

    plugins = with pkgs.tmuxPlugins; [
      yank
    ];

    # =========================
    # CONFIG
    # =========================

    inherit extraConfig;
  };
}
