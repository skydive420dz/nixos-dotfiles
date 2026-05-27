{
  programs.nvf.settings.vim.statusline.lualine = {
    enable = true;
    activeSection.a = [
      ''
        {
          "mode",
          icons_enabled = true,
          icon = "",
          separator = {
            left = '▎',
            right = ''
          },
        }
      ''
      ''
        {
          "",
          draw_empty = true,
          separator = { left = '', right = '' }
        }
      ''
    ];
  };
}
