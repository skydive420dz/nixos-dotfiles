{ ... }:
{
  programs.nvf.settings.vim.languages = {
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = true;

    python.enable = true;
    typescript.enable = true;
    markdown.enable = true;

    nix = {
      enable = true;
      format = {
        enable = true;
        type = [ "nixfmt" ];
      };
      lsp = {
        enable = true;
        servers = [ "nixd" ];
      };
      treesitter.enable = true;
    };

    toml = {
      enable = true;
      format = {
        enable = true;
        type = [ "taplo" ];
      };
      lsp = {
        enable = true;
        servers = [ "taplo" ];
      };
      treesitter.enable = true;
    };

    rust = {
      enable = true;
      extensions.crates-nvim.enable = true;
      lsp = {
        enable = true;
      };
    };

    bash = {
      enable = true;
      format = {
        enable = true;
        type = [ "shfmt" ];
      };
      lsp = {
        enable = true;
        servers = [ "bash-language-server" ];
      };
    };

    json = {
      enable = true;
      lsp = {
        enable = true;
        servers = [ "vscode-json-language-server" ];
      };
      treesitter.enable = true;
    };

    clang.enable = true;

    css = {
      enable = true;
      format = {
        enable = true;
        type = [ "prettier" ];
      };
      lsp = {
        enable = true;
        servers = [ "vscode-css-language-server" ];
      };
      treesitter.enable = true;
    };

    qml = {
      enable = true;
      format = {
        enable = true;
        type = [ "qmlformat" ];
      };
      lsp = {
        enable = true;
        servers = [ "qmlls" ];
      };
      treesitter.enable = true;
    };

    java.enable = true;

    lua = {
      enable = true;
      lsp.enable = true;
      format.enable = true;
      treesitter.enable = true;
    };
  };
}
