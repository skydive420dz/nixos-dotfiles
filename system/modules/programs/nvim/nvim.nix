{ pkgs, lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
  customLua = import ./lua.nix { };
in
{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        startPlugins = [
          pkgs.vimPlugins.friendly-snippets
          (pkgs.runCommand "nvim-local-snippets" { } ''
            mkdir -p $out/after/snippets/lua
            cat > $out/after/snippets/lua/lua.json <<'EOF'
            {
              "require": {
                "prefix": ["req", "require"],
                "body": ["require(''${1:module})$0"],
                "description": "Require module"
              }
            }
            EOF
          '')
        ];

        viAlias = false;
        vimAlias = true;
        debugMode = {
          enable = false;
          level = 16;
          logFile = "/tmp/nvim.log";
        };

        opts = {
          expandtab = true;
          ignorecase = true;
          inccommand = "split";
          laststatus = 3;
          number = true;
          relativenumber = true;
          scrolloff = 8;
          shiftwidth = 4;
          signcolumn = "yes";
          smartcase = true;
          smartindent = true;
          softtabstop = 4;
          splitbelow = true;
          splitright = true;
          tabstop = 4;
          wrap = false; # Fixes cinnamon.nvim 'wrap' warning
        };

        spellcheck = {
          enable = true;
          languages = [ "en_us" ];
        };

        debugger.nvim-dap = {
          enable = true;
          ui.enable = true;
        };

        theme.enable = false;

        visuals = {
          nvim-scrollbar.enable = true;
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          cinnamon-nvim.enable = true;
          fidget-nvim.enable = true;
          highlight-undo.enable = true;
          blink-indent.enable = true;
          indent-blankline.enable = false;
        };
        mini = {
          icons.enable = true;
          ai.enable = true;
          files.enable = true;
        };

        filetree.neo-tree.enable = false;
        tabline.nvimBufferline.enable = true;

        # Added explicit treesitter block to help NixOS healthcheck
        treesitter = {
          enable = true;
          highlight.enable = true;
          indent.enable = true;
        };

        binds = {
          whichKey = {
            enable = true;
            setupOpts = {
              preset = "helix";
              notify = false;
              delay = 500;
            };
          };
        };

        notify.nvim-notify.enable = true;
        projects.project-nvim.enable = true;

        utility = {
          ccc.enable = false;
          vim-wakatime.enable = false;
          diffview-nvim.enable = true;
          yanky-nvim.enable = false;
          icon-picker.enable = true;
          surround.enable = true;
          multicursors.enable = true;
          smart-splits = {
            enable = true;
            setupOpts.multiplexer_integration = mkLuaInline ''vim.env.TMUX and "tmux" or nil'';
          };
          undotree.enable = true;
          nvim-biscuits.enable = true;
          grug-far-nvim.enable = true;

          motion = {
            hop.enable = false;
            leap.enable = true;
            precognition.enable = true;
          };

          images = {
            image-nvim.enable = false;
            img-clip.enable = false;
          };
        };

        notes = {
          neorg.enable = false;
          orgmode.enable = false;
          todo-comments.enable = true;
        };

        terminal.toggleterm = {
          enable = true;
          lazygit.enable = true;
        };

        ui = {
          borders.enable = true;
          noice.enable = false;
          colorizer.enable = true;
          modes-nvim.enable = false;
          illuminate.enable = true;
          breadcrumbs = {
            enable = true;
            lualine.winbar.alwaysRender = true;
            navbuddy.enable = true;
          };

          smartcolumn = {
            enable = true;
            setupOpts.custom_colorcolumn = {
              nix = "110";
              java = "130";
              go = [
                "90"
                "130"
              ];
            };
          };
          fastaction.enable = true;
        };
        session.nvim-session-manager = {
          enable = true;
          setupOpts.autoload_mode = "Disabled";
          mappings = {
            saveCurrentSession = "<leader>Ss";
            loadSession = "<leader>Sl";
            loadLastSession = "<leader>Sr";
            deleteSession = "<leader>Sd";
          };
        };
        gestures.gesture-nvim.enable = false;
        comments.comment-nvim.enable = true;
        presence.neocord.enable = false;

        assistant = {
          chatgpt.enable = false;
          copilot.enable = false;
          codecompanion-nvim.enable = false;
          avante-nvim.enable = false;
        };

        clipboard.enable = true;

        luaConfigRC = customLua;

        formatter.conform-nvim.enable = true;
        fzf-lua.enable = false;
        telescope.enable = true;
        autopairs.nvim-autopairs.enable = true;
        lazy.enable = true;
      };
    };
  };
}
