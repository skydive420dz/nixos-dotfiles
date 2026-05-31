{ }:

{
  themeTokens = ''
    local sky_nvim = vim.fn.expand("~/.config/sky-nvim")
    if vim.fn.isdirectory(sky_nvim) == 1 then
      vim.opt.runtimepath:prepend(sky_nvim)
    end

    local ok_sky, sky = pcall(require, "sky")
    if ok_sky then
      sky.setup()
    else
      vim.notify("Sky live config unavailable: " .. tostring(sky), vim.log.levels.WARN, { title = "Neovim" })
    end

    local ok, err = pcall(vim.cmd.colorscheme, "sky")
    if not ok then
      vim.notify("Sky colorscheme unavailable: " .. tostring(err), vim.log.levels.WARN, { title = "Theme" })
    end
  '';
}
