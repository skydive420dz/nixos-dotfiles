{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  programs.nvf.settings.vim.dashboard = {
    dashboard-nvim.enable = false;
    alpha = {
      enable = true;
      theme = null;
      layout = [
        {
          type = "padding";
          val = 2;
        }
        {
          type = "text";
          val = [
            "                                                        "
            "             ████  ████                            "
            "             █████ █████                           "
            "              ██████████                          "
            "      ███████████████████                         "
            "     █████████████████████                        "
            "    ██████████████████████                       "
            "   ████████████████████████                      "
            "  ██████████████████████████                     "
            "  ██████████████████████████                     "
            "   ███████████████████████                       "
            "    █████████████████████                        "
            "        ███████████████                          "
            "          ████████████                              "
            "                                                        "
            "             N E O V I M   /   skydive420dz            "
            "                                                        "
          ];
          opts = {
            position = "center";
            hl = "AlphaHeader";
          };
        }
        {
          type = "padding";
          val = 1;
        }
        {
          type = "group";
          val = mkLuaInline ''
            (function()
              local dashboard = require("alpha.themes.dashboard")
              return {
                dashboard.button("n", "  New file", "<cmd>ene <bar> startinsert<cr>"),
                dashboard.button("e", "  Explorer", "<cmd>lua require('mini.files').open(vim.uv.cwd(), true)<cr>"),
                dashboard.button("f", "  Find file", "<cmd>Telescope find_files<cr>"),
                dashboard.button("g", "󰱼  Live grep", "<cmd>Telescope live_grep<cr>"),
                dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<cr>"),
                dashboard.button("s", "󰆓  Load session", "<cmd>SessionManager load_session<cr>"),
                dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
              }
            end)()
          '';
          opts = {
            spacing = 1;
          };
        }
      ];
    };
  };
}
