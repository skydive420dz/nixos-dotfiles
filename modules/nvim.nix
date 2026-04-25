{
  config,
  pkgs,
  lib,
  ...
}:
{

  #  home.packages = with pkgs; [ ];

  environment.systemPackages = with pkgs; [
  ];
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        startPlugins = [
          "chatgpt-nvim"
          "nvim-tree-lua"
          "nvim-treesitter"
          "nvim-treesitter-context"
          "nvim-treesitter-textobjects"
          "nvim-ts-autotag"
        ];
        viAlias = false;
        vimAlias = true;
        debugMode = {
          enable = false;
          level = 16;
          logFile = "/tmp/nvim.log";
        };

        # vim.opts and vim.options are aliased
        opts.expandtab = true;

        spellcheck = {
          enable = true;
          languages = [
            "en"
          ];
          #programmingWordlist.enable = true;
          #vim-dirtytalk.enable = true;

        };

        lsp = {
          enable = true;
          formatOnSave = true;
          lspkind.enable = false;
          lightbulb.enable = true;
          lspsaga.enable = false;
          trouble.enable = true;
          lspSignature.enable = !true; # conflicts with blink in maximal
          otter-nvim.enable = true;
          nvim-docs-view.enable = true;
          presets.harper.enable = true;
        };

        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;
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
          };

          rust = {
            enable = true;
            extensions.crates-nvim.enable = true;
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
          };
          java.enable = true;
          lua.enable = true;
          #          lua.treesitter.enable = true;
        };

        visuals = {
          nvim-scrollbar.enable = true;
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          cinnamon-nvim.enable = true;
          fidget-nvim.enable = true;
          highlight-undo.enable = true;
          blink-indent.enable = true;
          indent-blankline.enable = true;

        };

        statusline.lualine.enable = true;

        autocomplete = {
          nvim-cmp.enable = !true;
          blink-cmp.enable = true;
        };

        snippets.luasnip.enable = true;

        filetree = {
          neo-tree = {
            enable = true;
          };
        };

        tabline = {
          nvimBufferline.enable = true;
        };

        #        treesitter.context.enable = true;

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        notify = {
          nvim-notify.enable = true;
        };

        projects = {
          project-nvim.enable = true;
        };

        utility = {
          ccc.enable = false;
          vim-wakatime.enable = false;
          diffview-nvim.enable = true;
          yanky-nvim.enable = false;
          qmk-nvim.enable = false; # requires hardware specific options
          icon-picker.enable = true;
          surround.enable = true;
          leetcode-nvim.enable = true;
          multicursors.enable = true;
          smart-splits.enable = true;
          undotree.enable = true;
          nvim-biscuits.enable = true;
          grug-far-nvim.enable = true;

          motion = {
            hop.enable = true;
            leap.enable = true;
            precognition.enable = true;
          };

          images = {
            image-nvim.enable = false;
            img-clip.enable = true;
          };
        };

        notes = {
          neorg.enable = false;
          orgmode.enable = false;
          mind-nvim.enable = true;
          todo-comments.enable = true;
        };

        terminal = {
          toggleterm = {
            enable = true;
            lazygit.enable = true;
          };
        };

        ui = {
          borders.enable = true;
          noice.enable = true;
          colorizer.enable = true;
          modes-nvim.enable = false; # the theme looks terrible with catppuccin
          illuminate.enable = true;
          breadcrumbs = {
            enable = true;
            navbuddy.enable = true;
          };

          smartcolumn = {
            enable = true;
            setupOpts.custom_colorcolumn = {
              nix = "110";
              ruby = "120";
              java = "130";
              go = [
                "90"
                "130"
              ];
            };
          };
          fastaction.enable = true;
        };

        session = {
          nvim-session-manager.enable = false;
        };

        gestures = {
          gesture-nvim.enable = false;
        };

        comments = {
          comment-nvim.enable = true;
        };

        presence = {
          neocord.enable = false;
        };

        assistant = {
          chatgpt.enable = false;
          copilot = {
            enable = false;
            cmp.enable = false;
          };
          codecompanion-nvim.enable = false;
          avante-nvim.enable = false;
        };

        clipboard.enable = true;
        formatter.conform-nvim.enable = true;
        fzf-lua.enable = true;
        telescope.enable = true;
        autopairs.nvim-autopairs.enable = true;
        lazy.enable = true;
      };
    };
  };
}
