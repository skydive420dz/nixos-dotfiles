# Tmux

## Direction

Tmux should stay lean and intentional. Named session recipes are the clean
baseline, and resurrect/continuum are allowed as a convenience layer over that
baseline instead of being the source of truth.

## Plugins

- `yank` keeps copy-mode integration with the system clipboard.
- `sensibleOnTop` provides a small baseline of sane tmux defaults.
- `prefix-highlight` shows when tmux is waiting after `prefix`.
- `resurrect` saves/restores live tmux state when needed.
- `continuum` autosaves/restores live state, now acceptable because the
  sessionizer gives us clean recipes when we want to start fresh.

We still do not use a tmux vim-navigation plugin or fzf plugin. Navigation is
handled by our explicit tmux/smart-splits bindings, and the sessionizer calls
plain `fzf` directly.

## Sessionizer

The backend is `tmux-session`, installed from `home/modules/tmux-session.nix`.

Current entry points:

- `tmux-session` opens an `fzf` picker.
- `tmux-session main` opens or switches to `main`.
- `tmux-session dots` opens or switches to `dots`.
- `tmux-session qs` opens or switches to `qs`.
- `tm` calls `tmux-session main`.
- `tmd` calls `tmux-session dots`.
- `prefix+g` opens the picker inside a tmux popup.

Initial recipes:

- `main` starts in `$HOME`.
- `dots` starts in `$HOME/nixos-dotfiles`, with a `files` window split between
  `yazi` and a terminal, plus a second `term` window.
- `qs` starts in `$HOME/nixos-dotfiles`, with a `vim` window opened on
  `config/quickshell/shell.qml`, plus a second `term` window.
- `notes` starts in `$HOME/nixos-dotfiles/docs` and opens `README.md`.

Later session work should extend the same backend instead of adding parallel
aliases. Richer recipes can add windows, panes, and startup commands once the
base switcher feels right.
