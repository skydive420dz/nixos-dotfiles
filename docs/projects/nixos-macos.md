# macOS Dotfiles

## Current

- Managed separately in `../nixos-macos`.
- VS Code packages live on macOS, not NixOS.
- macOS keyboard repeat is the reference feel for NixOS.

## Commands

- `darwin-rebuild switch --flake .`
- `git status --short --branch`

## Important Files

- [macOS defaults](../../../nixos-macos/darwin/modules/defaults.nix)
- [macOS system](../../../nixos-macos/darwin/modules/darwin.nix)
- [VS Code packages](../../../nixos-macos/home-manager/modules/programs/vscode.nix)

## Decisions

- Do not add VS Code-specific setup to NixOS unless explicitly needed.
- Keep Mac and NixOS keyboard repeat feeling aligned.

## Next

- Keep upstream-sourced VS Code extensions current.
