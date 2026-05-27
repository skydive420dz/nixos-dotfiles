{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  programs.nvf.settings.vim = {
    autocomplete.blink-cmp = {
      enable = true;
      setupOpts = {
        snippets.preset = "mini_snippets";
        sources = {
          default = lib.mkForce [
            "snippets"
            "lsp"
            "path"
            "buffer"
          ];
          providers = {
            snippets.score_offset = 100;
            lsp.score_offset = 0;
            path.score_offset = -5;
            buffer.score_offset = -10;
          };
        };
        completion = {
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 400;
          };
          ghost_text.enabled = true;
          list.selection = {
            preselect = false;
            auto_insert = true;
          };
        };
        cmdline = {
          keymap.preset = "inherit";
          completion.menu.auto_show = true;
        };
        signature.enabled = true;
        fuzzy.implementation = "prefer_rust_with_warning";
        keymap = lib.mkForce {
          preset = "none";
          "<C-Space>" = [
            "show"
            "fallback"
          ];
          "<C-d>" = [
            "scroll_documentation_up"
            "fallback"
          ];
          "<C-e>" = [
            "hide"
            "fallback"
          ];
          "<C-f>" = [
            "scroll_documentation_down"
            "fallback"
          ];
          "<C-j>" = [
            "select_next"
            "fallback"
          ];
          "<C-k>" = [
            "select_prev"
            "fallback"
          ];
          "<C-l>" = [
            "select_and_accept"
            "fallback"
          ];
          "<CR>" = [
            "accept"
            "fallback"
          ];
          "<Tab>" = [
            "select_next"
            "snippet_forward"
            "fallback"
          ];
          "<S-Tab>" = [
            "select_prev"
            "snippet_backward"
            "fallback"
          ];
          "<Up>" = [
            "select_prev"
            "fallback"
          ];
          "<Down>" = [
            "select_next"
            "fallback"
          ];
        };
      };
    };

    snippets.luasnip.enable = false;
    mini.snippets = {
      enable = true;
      setupOpts.snippets = mkLuaInline ''
        {
          require("mini.snippets").gen_loader.from_lang(),
        }
      '';
    };
  };
}
