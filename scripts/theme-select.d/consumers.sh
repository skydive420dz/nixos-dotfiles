update_session_env() {
  local gtk_theme
  gtk_theme="$(gtk_env_theme)"

  export SKY_THEME="$style"
  export BAT_THEME=Sky
  export BAT_STYLE="numbers,changes,header"
  export STARSHIP_CONFIG="$current_dir/starship.toml"
  export GTK_THEME="$gtk_theme"
  export GTK2_RC_FILES="$config_home/gtk-2.0/gtkrc"
  export QT_STYLE_OVERRIDE=Fusion
  export QT_QPA_PLATFORMTHEME=qt6ct
  export QT_QUICK_CONTROLS_STYLE=org.kde.desktop

  systemctl --user set-environment \
    "SKY_THEME=$SKY_THEME" \
    "BAT_THEME=$BAT_THEME" \
    "BAT_STYLE=$BAT_STYLE" \
    "STARSHIP_CONFIG=$STARSHIP_CONFIG" \
    "GTK_THEME=$GTK_THEME" \
    "GTK2_RC_FILES=$GTK2_RC_FILES" \
    "QT_STYLE_OVERRIDE=$QT_STYLE_OVERRIDE" \
    "QT_QPA_PLATFORMTHEME=$QT_QPA_PLATFORMTHEME" \
    "QT_QUICK_CONTROLS_STYLE=$QT_QUICK_CONTROLS_STYLE" >/dev/null 2>&1 || true

  dbus-update-activation-environment --systemd \
    SKY_THEME BAT_THEME BAT_STYLE STARSHIP_CONFIG GTK_THEME GTK2_RC_FILES \
    QT_STYLE_OVERRIDE QT_QPA_PLATFORMTHEME QT_QUICK_CONTROLS_STYLE >/dev/null 2>&1 || true
}

reload_consumers() {
  tmux source-file "$current_dir/tmux.conf" >/dev/null 2>&1 || true
  systemctl --user restart mako.service >/dev/null 2>&1 || true
  systemctl --user restart quickshell.service >/dev/null 2>&1 || true
}
