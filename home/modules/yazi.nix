{ pkgs, ... }:

let
  tokens = import ../../theme/tokens.nix;
in
{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    shellWrapperName = "y";

    extraPackages = with pkgs; [
      ouch
    ];

    settings = {
      manager = {
        ratio = [
          1
          3
          4
        ];
        sort_by = "natural";
        show_hidden = true;
        show_symlink = true;
      };

      preview = {
        tab_size = 2;
        max_width = 800;
        max_height = 1000;
        image_delay = 0;
      };

      opener.edit = [
        {
          run = ''nvim "$@"'';
          block = true;
          desc = "Open in Neovim";
        }
      ];
    };

    keymap.manager.prepend_keymap = [
      {
        on = [
          "g"
          "d"
        ];
        run = "cd ~/Downloads";
        desc = "Go to Downloads";
      }
      {
        on = [ "!" ];
        run = ''shell "$SHELL" --block'';
        desc = "Drop to Shell";
      }
      {
        on = [ "C" ];
        run = "plugin smart-enter";
        desc = "Enter directory or open file";
      }
    ];

    theme = import ./yazi/theme.nix {
      inherit (tokens) palette;
    };

    plugins = {
      ouch = ./yazi/plugins/ouch.yazi;
      smart-enter = ./yazi/plugins/smart-enter.yazi;
    };
  };
}
