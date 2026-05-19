# Neovim

## Structure

Neovim follows the module-directory convention:

- `system/modules/programs/nvim/default.nix` imports local pieces.
- `system/modules/programs/nvim/nvim.nix` owns the main `programs.nvf` module.
- `system/modules/programs/nvim/lua.nix` owns custom Lua injected through
  `luaConfigRC`.

Keep future Neovim helpers inside `system/modules/programs/nvim/` unless they
are shared by another unit.
