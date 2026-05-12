local function smart_move(method, fallback)
  return function()
    local ok, splits = pcall(require, "smart-splits")
    if ok and type(splits[method]) == "function" then
      splits[method]()
      return
    end

    vim.cmd("wincmd " .. fallback)
  end
end

local group = vim.api.nvim_create_augroup("UserNeoTreeNavigation", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "neo-tree",
  callback = function(event)
    local function opts(desc)
      return { buffer = event.buf, silent = true, desc = desc }
    end

    vim.keymap.set("n", "<C-h>", smart_move("move_cursor_left", "h"), opts("Move left"))
    vim.keymap.set("n", "<C-j>", smart_move("move_cursor_down", "j"), opts("Move down"))
    vim.keymap.set("n", "<C-k>", smart_move("move_cursor_up", "k"), opts("Move up"))
    vim.keymap.set("n", "<C-l>", smart_move("move_cursor_right", "l"), opts("Move right"))
  end,
})
