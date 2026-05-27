{ pkgs, lib, ... }:
{
  programs.nvf.settings.vim.extraPackages =
    with pkgs;
    [
      # General editor/project utilities.
      tree-sitter # Satisfies tree-sitter-cli requirement
      ripgrep
      fd

      # Enabled language support should be operational when Neovim opens a project.
      # Project flakes can still override versions for repo-specific work.
      bash-language-server
      basedpyright
      clang-tools
      cargo
      gcc
      jdt-language-server
      lua-language-server
      marksman
      nixd
      nixfmt
      nodejs
      prettier
      rustc
      rust-analyzer
      shfmt
      stylua
      taplo
      typescript
      typescript-language-server
      vscode-langservers-extracted

      # Debuggers and framework-specific tools.
      lldb # Fixes Rustaceanvim debug warning
      qt6.qtdeclarative
      qt6.qttools
    ]
    ++ lib.optionals stdenv.isDarwin [
      pngpaste
    ]
    ++ lib.optionals stdenv.isLinux [
      quickshell
    ];
}
