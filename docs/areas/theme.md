# Global Theme

The Sky theme selector is system-wide state. Quickshell exposes a button for it,
but Quickshell does not own the palette.

## Ownership Model

- `theme/styles.json` is the source registry for shared style data.
- Current styles:
  - `SkyDark`: dark Compline-derived palette.
  - `SkyLight`: light companion palette.
- `scripts/theme-select` is the runtime selector entrypoint.
- `scripts/theme-select.d/` owns helper functions, generated output writers,
  session environment updates, and live app reloads.
- `~/.config/theme/current-style` stores the active runtime style.
- `~/.config/theme/current/` stores generated runtime files.
- `theme/tokens.nix` exports the rebuild-time default for Nix consumers.
- App configs consume generated files or shared tokens. They should not invent
  private palettes when the color belongs to the global style.

## Source Files

- `theme/styles.json`: semantic colors, terminal colors, and palette values.
- `scripts/theme-select`: public command and control flow.
- `scripts/theme-select.d/core.sh`: shared helpers for colors, jq, and file
  targets.
- `scripts/theme-select.d/state.sh`: current-style selection helpers.
- `scripts/theme-select.d/consumers.sh`: session environment and live reloads.
- `scripts/theme-select.d/generators/`: per-output-family runtime generators.
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
- The launcher and clipboard picker explicitly pass the generated fuzzel config.
  Plain manual `fuzzel` uses `config/fuzzel/fuzzel.ini` as a SkyDark fallback.
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

## Coverage Audit 2026-05-30

Covered by runtime generation:

- Quickshell, Mako, Kitty, tmux, Starship, fuzzel launcher/clipboard,
  qutebrowser, btop, bat, GTK, Qt, KDE-style globals, zsh/fzf env, and Doom
  Emacs runtime style state.

Fixed in this pass:

- `scripts/clipboard-toggle` now passes the generated fuzzel config, matching
  `scripts/launcher-toggle`.
- `config/fuzzel/fuzzel.ini` now uses SkyDark fallback colors instead of an old
  blue palette.

Known open items:

- NVF still declares `catppuccin`/`mocha` in
  `system/modules/programs/nvim/nvim.nix`. Replace it with a Sky-owned theme or
  decide that NVF is being retired.
- Plymouth still uses `catppuccin-mocha` in `system/modules/boot.nix`. This is a
  rebuild-time boot asset and needs a Sky boot theme if we want full coverage.
- aerc uses a static `config/aerc/stylesets/sky` file. It matches SkyDark, but
  it does not currently follow `SkyLight` at runtime.
- Doom Emacs works with native Sky themes, but the theme files duplicate color
  values from `theme/styles.json`. A later cleanup can generate those files or
  load tokens from a single source.
- `theme/yazi.nix` and a few fallback modules still use old palette field names
  like `rosewater` and `mauve`. The values are Sky values, but the names are
  inherited vocabulary and may be worth renaming once the palette settles.
- `config/quickshell/common/Theme.qml` intentionally keeps hard-coded SkyDark
  fallback colors for startup before generated runtime state exists.

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

- `scripts/theme-select` stays the stable public command. Generator code is now
  split under `scripts/theme-select.d/` so app-specific changes can happen in a
  smaller file without changing selector behavior.
- After the Sky themes settle, a separate Sky theme package/repo could reduce
  surface area inside these dotfiles.
- Markdown notes can move to Org later. Do that as a separate documentation
  migration so theme behavior does not get mixed with format churn.
