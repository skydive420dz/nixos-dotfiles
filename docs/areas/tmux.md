# Tmux

## Direction

Tmux should stay lean and intentional. We removed automatic resurrect/continuum
state restore in favor of named session recipes that can be recreated from a
known shape.

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
