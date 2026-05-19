# Module Structure

## Direction

Modules should stay easy to scan as they grow. Small single-purpose modules can
remain as one file, but any unit with generated config, helper scripts, or
multiple related concerns should move into a directory.

## Shape

Use this layout for grown-up units:

- `default.nix` imports local pieces only.
- `<unit>.nix` contains the main Nix/Home Manager module.
- `extra-config.nix` contains generated app-native config strings when they get
  too large for the main module.
- Named support files, such as `sessions.nix`, `scripts.nix`, or `theme.nix`,
  contain related helpers for that unit.

Examples:

- `home/modules/programs/tmux/`
- `system/modules/programs/nvim/`

## Rules

- Keep behavior changes separate from structure moves unless a tiny cleanup is
  needed to preserve portability.
- Prefer local helpers inside the unit directory over more flat files in
  `home/modules/` or `system/modules/`.
- Respect the category tree first: programs live under `programs/`, services
  under `services/`, desktop/session pieces under `desktop/`, and only
  cross-cutting modules stay at the category root.
- Keep shared/global concerns outside unit directories only when multiple units
  genuinely use them.
