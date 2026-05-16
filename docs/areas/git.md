# Git Workflow

## Rhythm

- Work in small checkpoints.
- Keep clean git state between jobs.
- Sync live machine before testing when needed.
- Commit only after the live behavior is accepted.

## Commands

- `git status --short --branch`
- `git diff --stat`
- `git log --oneline -5`
- `git push`

## Remote NixOS Checkout

- Host: `192.168.1.175`
- Repo: `~/nixos-dotfiles`

When live-syncing files directly to NixOS, remember the remote checkout can look dirty even after local commits are pushed. Clean it by fetching/resetting only after preserving any real local diff.
