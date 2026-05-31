local M = {}

local function format_buffer()
  local ok, conform = pcall(require, "conform")
  if ok then
    conform.format({ async = true, lsp_format = "fallback" })
  else
    vim.lsp.buf.format({ async = true })
  end
end

function M.setup()
  vim.keymap.set("n", "<leader>lf", format_buffer, { desc = "Format buffer" })
  vim.keymap.set("n", "<leader>lF", "<cmd>ConformInfo<cr>", { desc = "Conform info" })
end

return M
