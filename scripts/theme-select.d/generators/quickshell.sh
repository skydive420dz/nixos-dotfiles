write_quickshell_theme() {
  prepare_target "$current_dir/quickshell.json"
  cat > "$current_dir/quickshell.json" <<EOF
{
  "name": "$style",
  "flavor": "$(hex '.[$style].flavor')",
  "bg": "$(hex '.[$style].semantic.background')",
  "bgAlpha": 0.82,
  "panel": "$(hex '.[$style].semantic.surface')",
  "panelAlpha": 0.78,
  "panelAlt": "$(hex '.[$style].semantic.surfaceStrong')",
  "panelAltAlpha": 0.84,
  "border": "$(hex '.[$style].semantic.border')",
  "borderAlpha": 0.58,
  "text": "$(hex '.[$style].semantic.foreground')",
  "muted": "$(hex '.[$style].semantic.muted')",
  "accent": "$(hex '.[$style].semantic.accent')",
  "danger": "$(hex '.[$style].semantic.danger')",
  "warning": "$(hex '.[$style].semantic.warning')",
  "good": "$(hex '.[$style].semantic.success')"
}
EOF

  prepare_target "$current_dir/quickshell-signal"
  date +%s%N > "$current_dir/quickshell-signal"
}
