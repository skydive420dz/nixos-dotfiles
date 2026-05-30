# Global Theme

The Sky theme selector is system-wide state. Quickshell exposes a button for it,
but Quickshell does not own the palette.

## Ownership Model

- `theme/styles.json` is the source registry for shared style data.
- Current styles:
  - `SkyDark`: dark Compline-derived palette.
  - `SkyLight`: light companion palette.
- `scripts/theme-select` is the runtime selector and generator.
- `~/.config/theme/current-style` stores the active runtime style.
- `~/.config/theme/current/` stores generated runtime files.
- `theme/tokens.nix` exports the rebuild-time default for Nix consumers.
- App configs consume generated files or shared tokens. They should not invent
  private palettes when the color belongs to the global style.

## Source Files

- `theme/styles.json`: semantic colors, terminal colors, and palette values.
- `scripts/theme-select`: generates runtime config files from `styles.json`.
- `theme/tokens.nix`: Nix-side fallback/default tokens.
- `config/quickshell/common/Theme.qml`: runtime reader for Quickshell tokens.
- `config/doom/theme.el`: loads the active Sky theme in Doom Emacs.
- `config/doom/themes/sky-theme-common.el`: shared Doom face definitions.
- `config/doom/themes/sky-dark-theme.el`: native Doom `SkyDark` theme.
- `config/doom/themes/sky-light-theme.el`: native Doom `SkyLight` theme.
- Home Manager modules install packages, link scripts, and set fallback session
  variables. They should not become per-project or per-machine theme patches.

## Generated Files

Runtime state:

- `~/.config/theme/current-style`

Generated under `~/.config/theme/current/`:

- `quickshell.json`
- `quickshell-signal`
- `kitty.conf`
- `mako.conf`
- `qutebrowser.py`
- `fuzzel.ini`
- `starship.toml`
- `tmux.conf`
- `emacs-theme.el`
- `env`

Generated outside the current bundle:

- `~/.config/btop/themes/sky.theme`
- `~/.config/bat/config`
- `~/.config/bat/themes/Sky.tmTheme`
- `~/.config/gtk-2.0/gtkrc`
- `~/.config/gtk-3.0/settings.ini`
- `~/.config/gtk-3.0/gtk.css`
- `~/.config/gtk-4.0/settings.ini`
- `~/.config/gtk-4.0/gtk.css`
- `~/.config/qt5ct/colors/Sky.conf`
- `~/.config/qt5ct/qt5ct.conf`
- `~/.config/qt6ct/colors/Sky.conf`
- `~/.config/qt6ct/qt6ct.conf`
- `~/.config/kdeglobals`

## Runtime-Themed Apps

These can change without `nrs`, usually after `theme-select toggle` or
`theme-select SkyDark`/`theme-select SkyLight`.

- Quickshell reads `quickshell.json` and watches `quickshell-signal`. The
  selector also restarts `quickshell.service`.
- Mako is restarted and reads `mako.conf`.
- Kitty reloads through `kitty @ load-config`.
- tmux reloads through `tmux source-file ~/.config/theme/current/tmux.conf`.
- Starship uses `STARSHIP_CONFIG`; new prompts pick up the generated config.
- zsh and fzf use `~/.config/theme/current/env`; existing shells may need to
  source it again or start fresh.
- fuzzel uses `fuzzel.ini` on the next launch.
- qutebrowser loads `qutebrowser.py`; existing windows may need a reload or
  restart depending on what qutebrowser has already cached.
- btop and bat use their generated themes on the next launch or refresh.
- GTK and Qt apps get generated settings/palettes. Existing GUI apps usually
  need restart; new processes should pick up the active style.
- Doom Emacs has native `sky-dark` and `sky-light` themes. After changing the
  global style, use `SPC h r t` to reload the active Sky theme in a running
  Emacs session.

## Rebuild-Themed Apps

These are still owned by Nix/Home Manager and need `nrs` or a rebuild when the
definition changes.

- Package installation for theme tools, fonts, icons, GTK/Qt helpers, and apps.
- Home Manager service definitions and fallback session variables.
- Plymouth and boot-time assets.
- Any module still consuming `theme/tokens.nix` directly as a static fallback.
- NVF/Neovim is not currently part of the runtime Sky selector.

## Commands

```sh
theme-select list
theme-select current
theme-select apply
theme-select toggle
theme-select SkyDark
theme-select SkyLight
```

Health checks after a rebuild or reboot:

```sh
theme-select current
systemctl --user show-environment | grep -E '^(SKY_THEME|GTK_THEME|QT_)'
systemctl --user is-active quickshell.service mako.service
journalctl --user -u quickshell.service -u mako.service -b --no-pager
```

## Rules

- Quickshell may trigger the selector, but it must not own global palette data.
- Nix installs packages and fallback defaults; live color state belongs under
  `~/.config/theme/current/`.
- New themed apps should consume `theme/styles.json` through Nix or the
  generated runtime bundle.
- Avoid local app palettes. If a color should be shared, add it to the style
  registry and regenerate from there.
- Avoid machine-specific editor fixes for project theme data. Project metadata
  belongs to the project; global editor config stays general-purpose.

## Cleanup Notes

- `scripts/theme-select` is the current owner and is getting large. If it starts
  slowing changes down, split generator helpers by app while preserving the same
  public command.
- After the Sky themes settle, a separate Sky theme package/repo could reduce
  surface area inside these dotfiles.
- Markdown notes can move to Org later. Do that as a separate documentation
  migration so theme behavior does not get mixed with format churn.
