current_style() {
  if [ -r "$state_file" ]; then
    read -r style < "$state_file"
    if style_exists "$style"; then
      printf '%s\n' "$style"
      return
    fi
  fi

  printf 'SkyDark\n'
}

select_style() {
  case "${1:-apply}" in
    apply) current_style ;;
    toggle)
      case "$(current_style)" in
        SkyDark) printf 'SkyLight\n' ;;
        *) printf 'SkyDark\n' ;;
      esac
      ;;
    *)
      printf '%s\n' "$1"
      ;;
  esac
}
