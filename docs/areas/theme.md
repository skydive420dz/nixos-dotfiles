# Global Theme

The global theme selector is system-wide, not Quickshell-specific.

## Source Of Truth

- `theme/styles.json` defines the available styles.
- Current styles:
  - `SkyDark`: dark Compline-derived palette.
  - `SkyLight`: light companion palette.
- `theme/tokens.nix` exports `SkyDark` as the declarative rebuild-time default
  for existing Nix consumers.

## Runtime State

- `scripts/theme-select` owns the live selected style.
- Runtime generated files live under `~/.config/theme/current/`.
- `theme-select apply` regenerates files for the current style.
- `theme-select toggle` switches `SkyDark`/`SkyLight` and reloads live
  consumers where possible.

## Current Consumers

- Quickshell reads `~/.config/theme/current/quickshell.json`.
- Kitty includes `~/.config/theme/current/kitty.conf`.
- Mako starts with `~/.config/theme/current/mako.conf`.
- btop uses the generated `sky` theme.
- bat uses the generated `Sky` theme.
- zsh sources `~/.config/theme/current/env` for shell tool colors.
- fzf receives generated colors through `FZF_DEFAULT_OPTS`.
- Starship receives generated prompt colors through `STARSHIP_CONFIG`.
- tmux sources `~/.config/theme/current/tmux.conf`.
- qutebrowser loads `~/.config/theme/current/qutebrowser.py`, with a
  rebuild-time fallback generated from `theme/tokens.nix`.
- fuzzel is launched with `~/.config/theme/current/fuzzel.ini`.
- Doom Emacs loads generated tokens from
  `~/.config/theme/current/emacs-theme.el`, with SkyDark fallback tokens in
  `config/doom/theme.el`.
- GTK 2/3/4 receive generated settings and color keys.
- Qt 5/6 receive generated `qt5ct`/`qt6ct` palettes, plus `kdeglobals` for
  Qt/KDE apps that read KDE color roles.

## Rules

- Quickshell may trigger the selector, but it must not own global palette data.
- Nix installs packages and fallback defaults; live color state belongs under
  `~/.config/theme/current/`.
- New themed apps should consume `theme/styles.json` through Nix or the generated
  runtime bundle.
- Avoid private one-off palettes in app modules. If a color should be shared,
  add it to the style registry and regenerate from there.
