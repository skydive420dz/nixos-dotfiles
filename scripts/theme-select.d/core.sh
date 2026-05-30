usage() {
  cat <<'EOF'
usage: theme-select [apply|current|list|toggle|SkyDark|SkyLight]

Global theme selector.
  apply      regenerate files for the current style without restarting services
  current    print the active style
  list       print available styles
  toggle     switch between SkyDark and SkyLight
EOF
}

need_jq() {
  if [ -z "$jq_bin" ]; then
    jq_bin="$(type -P jq 2>/dev/null || true)"
  fi

  if [ -z "$jq_bin" ]; then
    for candidate in \
      "/etc/profiles/per-user/${USER:-}/bin/jq" \
      "$HOME/.nix-profile/bin/jq" \
      "/run/current-system/sw/bin/jq"; do
      if [ -x "$candidate" ]; then
        jq_bin="$candidate"
        break
      fi
    done
  fi

  if [ -z "$jq_bin" ]; then
    printf 'theme-select: jq is required\n' >&2
    exit 1
  fi
}

jq() {
  "$jq_bin" "$@"
}

style_exists() {
  jq -e --arg style "$1" 'has($style)' "$styles_json" >/dev/null
}
hex() {
  jq -r --arg style "$style" "$1" "$styles_json"
}

hex_raw() {
  hex "$1" | sed 's/^#//'
}

theme_flavor() {
  hex '.[$style].flavor'
}

gtk_env_theme() {
  case "$(theme_flavor)" in
    light) printf 'Adwaita\n' ;;
    *) printf 'Adwaita:dark\n' ;;
  esac
}

prepare_target() {
  local target="$1"
  local parent="${target%/*}"

  mkdir -p "$parent"

  if [ -L "$target" ]; then
    local link_target
    link_target="$(readlink "$target")"
    case "$link_target" in
      /nix/store/*) rm -f "$target" ;;
    esac
  fi
}
