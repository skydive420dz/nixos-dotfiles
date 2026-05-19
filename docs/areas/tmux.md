# Tmux

## Direction

Tmux should stay lean and intentional. We removed automatic resurrect/continuum
state restore in favor of named session recipes that can be recreated from a
known shape.

## Sessionizer

The backend is `tmux-session`, installed from `home/home.nix`.

Current entry points:

- `tmux-session` opens an `fzf` picker.
- `tmux-session main` opens or switches to `main`.
- `tmux-session dots` opens or switches to `dots`.
- `tm` calls `tmux-session main`.
- `tmd` calls `tmux-session dots`.
- `prefix+g` opens the picker inside a tmux popup.

Initial recipes are intentionally simple:

- `main` starts in `$HOME`.
- `dots` starts in `$HOME/nixos-dotfiles`.
- `quickshell` starts in `$HOME/nixos-dotfiles`.
- `notes` starts in `$HOME/Documents`.

Later session work should extend the same backend instead of adding parallel
aliases. Richer recipes can add windows, panes, and startup commands once the
base switcher feels right.
