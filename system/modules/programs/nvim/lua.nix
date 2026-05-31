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

  navigation = ''
    local function lsp_clients_for_buffer()
      return vim.lsp.get_clients({ bufnr = 0 })
    end

    vim.api.nvim_create_user_command("LspInfo", function()
      local lines = { "LSP clients for current buffer:", "" }
      local clients = lsp_clients_for_buffer()

      if #clients == 0 then
        table.insert(lines, "  none")
      else
        for _, client in ipairs(clients) do
          local root = client.config and client.config.root_dir or "--"
          local cmd = client.config and client.config.cmd or {}
          table.insert(lines, ("  %s (id: %s)"):format(client.name, client.id))
          table.insert(lines, ("    root: %s"):format(root or "--"))
          table.insert(lines, ("    cmd: %s"):format(table.concat(cmd, " ")))
          table.insert(lines, ("    definition: %s"):format(tostring(client.server_capabilities.definitionProvider)))
          table.insert(lines, ("    document symbols: %s"):format(tostring(client.server_capabilities.documentSymbolProvider)))
          table.insert(lines, "")
        end
      end

      vim.cmd("botright new")
      vim.bo.buftype = "nofile"
      vim.bo.bufhidden = "wipe"
      vim.bo.swapfile = false
      vim.bo.filetype = "markdown"
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    end, { desc = "Show LSP clients for the current buffer" })

    vim.api.nvim_create_user_command("LspRestart", function()
      local clients = lsp_clients_for_buffer()
      if #clients == 0 then
        vim.notify("No LSP clients attached to this buffer", vim.log.levels.INFO, { title = "LSP" })
        return
      end

      for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id, true)
      end

      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(0) then
          vim.cmd("edit")
        end
      end, 300)
    end, { desc = "Restart LSP clients for the current buffer" })

    vim.api.nvim_create_user_command("LspLog", function()
      vim.cmd("edit " .. vim.fn.fnameescape(vim.lsp.get_log_path()))
    end, { desc = "Open the Neovim LSP log" })

    local yank_highlight_group = vim.api.nvim_create_augroup("UserYankHighlight", { clear = true })
    vim.api.nvim_create_autocmd("TextYankPost", {
      group = yank_highlight_group,
      desc = "Highlight yanked text",
      callback = function()
        vim.hl.on_yank()
      end,
    })

    -- Neovim terminals inherit from the Neovim process, so recover the
    -- Hyprland instance when Neovim starts from a stale environment.
    if (vim.env.HYPRLAND_INSTANCE_SIGNATURE == nil or vim.env.HYPRLAND_INSTANCE_SIGNATURE == "") and vim.env.XDG_RUNTIME_DIR then
      local hypr_runtime = vim.env.XDG_RUNTIME_DIR .. "/hypr"
      local newest_signature = nil
      local newest_mtime = 0

      local ok, iter = pcall(vim.fs.dir, hypr_runtime)
      if ok and iter then
        for name, kind in iter do
          if kind == "directory" then
            local stat = vim.uv.fs_stat(hypr_runtime .. "/" .. name)
            if stat and stat.mtime and stat.mtime.sec > newest_mtime then
              newest_signature = name
              newest_mtime = stat.mtime.sec
            end
          end
        end
      end

      if newest_signature then
        vim.env.HYPRLAND_INSTANCE_SIGNATURE = newest_signature
      end
    end

    -- Smart-splits should talk to tmux when Neovim is running inside tmux.
    if vim.env.TMUX then
      vim.g.smart_splits_multiplexer_integration = "tmux"
    end

    local function smart_resize(method, fallback)
      return function()
        local ok, splits = pcall(require, "smart-splits")
        if ok and type(splits[method]) == "function" then
          splits[method]()
          return
        end

        vim.cmd(fallback)
      end
    end

    -- Spelling
    vim.keymap.set("n", "]s", "]s", { desc = "Next spelling error" })
    vim.keymap.set("n", "[s", "[s", { desc = "Previous spelling error" })
    vim.keymap.set("n", "<leader>zg", "zg", { desc = "Add word to dictionary" })
    vim.keymap.set("n", "<leader>zw", "zw", { desc = "Mark word wrong" })
    vim.keymap.set("n", "<leader>z=", "z=", { desc = "Spelling suggestions" })

    -- Markdown link navigation
    local markdown_navigation_group = vim.api.nvim_create_augroup("UserMarkdownNavigation", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = markdown_navigation_group,
      pattern = "markdown",
      callback = function(event)
        vim.opt_local.foldenable = true
        vim.opt_local.foldlevel = 99

        if vim.treesitter and vim.treesitter.foldexpr then
          vim.opt_local.foldmethod = "expr"
          vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        else
          vim.opt_local.foldmethod = "indent"
        end

        local link_target_pattern = [=[\[[^]]\+\](\zs[^)]\+)]=]

        local function jump_link(flags)
          return function()
            local found = vim.fn.search(link_target_pattern, flags)
            if found == 0 then
              vim.notify("No markdown link found", vim.log.levels.INFO, { title = "Markdown" })
            end
          end
        end

        local opts = { buffer = event.buf, silent = true }
        vim.keymap.set("n", "]u", jump_link("W"), vim.tbl_extend("force", opts, { desc = "Next markdown link" }))
        vim.keymap.set("n", "[u", jump_link("bW"), vim.tbl_extend("force", opts, { desc = "Previous markdown link" }))
      end,
    })

    local function mini_files_open(path)
      return function()
        local ok, files = pcall(require, "mini.files")
        if not ok then
          vim.notify("mini.files is not available", vim.log.levels.WARN, { title = "Files" })
          return
        end

        files.open(path(), true)
      end
    end

    -- Pane and file navigation
    vim.keymap.set("n", "<leader>e", mini_files_open(function()
      local current = vim.api.nvim_buf_get_name(0)
      return current ~= "" and current or vim.uv.cwd()
    end), { desc = "Open MiniFiles" })
    vim.keymap.set("n", "<leader>E", mini_files_open(function()
      return vim.uv.cwd()
    end), { desc = "Open MiniFiles cwd" })
    vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle Undotree" })
    vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
    vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
    vim.keymap.set("n", "<leader>bN", "<cmd>enew<cr>", { desc = "󰈔 New buffer" })
    vim.keymap.set("n", "<leader>bx", "<cmd>bdelete<cr>", { desc = "󰅖 Close buffer" })

    vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "󰓩 New tab" })
    vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<cr>", { desc = "󰅖 Close tab" })
    vim.keymap.set("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "󰝤 Only tab" })

    vim.keymap.set("n", "<Left>", smart_resize("resize_left", "vertical resize -2"), { desc = "󰁍 Resize left" })
    vim.keymap.set("n", "<Down>", smart_resize("resize_down", "resize +2"), { desc = "󰁅 Resize down" })
    vim.keymap.set("n", "<Up>", smart_resize("resize_up", "resize -2"), { desc = "󰁝 Resize up" })
    vim.keymap.set("n", "<Right>", smart_resize("resize_right", "vertical resize +2"), { desc = "󰁔 Resize right" })

    vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "󰤻 Vertical split" })
    vim.keymap.set("n", "<leader>ws", "<cmd>split<cr>", { desc = "󰤼 Horizontal split" })
    vim.keymap.set("n", "<leader>wx", "<cmd>close<cr>", { desc = "󰅖 Close window" })
    vim.keymap.set("n", "<leader>wo", "<cmd>only<cr>", { desc = "󰝤 Only window" })
    vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "󰇽 Equalize windows" })

    vim.keymap.set("n", "<leader><leader>w", "<cmd>write<cr>", { desc = "󰆓 Write file" })
    vim.keymap.set("n", "<leader>qq", "<cmd>quit<cr>", { desc = "󰗼 Quit" })
    vim.keymap.set("n", "<leader>qa", "<cmd>quitall<cr>", { desc = "󰩈 Quit all" })
    vim.keymap.set("n", "<leader>qw", "<cmd>wquit<cr>", { desc = "󰆓 Write and quit" })
    vim.keymap.set("n", "<leader>qf", "<cmd>quit!<cr>", { desc = "󰜺 Force quit" })

    -- Navigation Hints Toggle
    vim.keymap.set("n", "<leader>pt", "<cmd>Precognition toggle<cr>", { desc = "Toggle Hints" })

    local function format_buffer()
      local ok, conform = pcall(require, "conform")
      if ok then
        conform.format({ async = true, lsp_format = "fallback" })
      else
        vim.lsp.buf.format({ async = true })
      end
    end

    local function open_navbuddy()
      local ok, navbuddy = pcall(require, "nvim-navbuddy")
      if ok then
        navbuddy.open()
      else
        vim.notify("nvim-navbuddy is not available", vim.log.levels.WARN, { title = "LSP" })
      end
    end

    local function code_action()
      local ok, fastaction = pcall(require, "fastaction")
      if ok then
        fastaction.code_action()
      else
        vim.lsp.buf.code_action()
      end
    end

    vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open Diffview" })
    vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
    vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })

    vim.keymap.set("n", "<leader>rr", "<cmd>GrugFar<cr>", { desc = "Replace in project" })
    vim.keymap.set("n", "<leader>rw", "<cmd>GrugFarWithin<cr>", { desc = "Replace in scope" })
    vim.keymap.set("x", "<leader>rw", ":GrugFarWithin<cr>", { desc = "Replace selection" })

    vim.keymap.set("n", "<leader>in", "<cmd>IconPickerNormal<cr>", { desc = "Pick icon" })
    vim.keymap.set("n", "<leader>ii", "<cmd>IconPickerInsert<cr>", { desc = "Insert icon" })
    vim.keymap.set("n", "<leader>iy", "<cmd>IconPickerYank<cr>", { desc = "Yank icon" })
    vim.keymap.set("n", "<leader>ip", "<cmd>PasteImage<cr>", { desc = "Paste image" })

    vim.keymap.set("n", "<leader>lf", format_buffer, { desc = "Format buffer" })
    vim.keymap.set("n", "<leader>lF", "<cmd>ConformInfo<cr>", { desc = "Conform info" })

    vim.keymap.set("n", "<leader>pl", "<cmd>Lazy<cr>", { desc = "Lazy" })
    vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
    vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })
    vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Vertical terminal" })
    vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
      callback = function(event)
        local opts = { buffer = event.buf, silent = true }
        vim.keymap.set("n", "<leader>ln", open_navbuddy, vim.tbl_extend("force", opts, { desc = "Navbuddy" }))
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
        vim.keymap.set({ "n", "x" }, "<leader>la", code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover docs" }))
      end,
    })

    local ok_which_key, which_key = pcall(require, "which-key")
    if ok_which_key then
      which_key.add({
        { "g", group = "󰁔 Go / LSP" },
        { "gd", desc = "Go to definition" },
        { "gD", desc = "Go to declaration" },
        { "gi", desc = "Go to implementation" },
        { "gr", group = "󰁔 LSP actions" },
        { "<leader>b", group = "󰓩 Buffers" },
        { "<leader>bm", group = "󰁌 Move Buffer" },
        { "<leader>bs", group = "󰒺 Sort Buffers" },
        { "<leader>d", group = " Debug" },
        { "<leader>dg", group = "󰆹 Debug Step" },
        { "<leader>dv", group = "󰕮 Debug Stack" },
        { "<leader>f", group = "󰱼 Find" },
        { "<leader>fl", group = " LSP Search" },
        { "<leader>fv", group = " Git Search" },
        { "<leader>fvc", group = "󰜘 Commits" },
        { "<leader>g", group = " Git / Diff" },
        { "<leader>i", group = "󰀻 Insert / Media" },
        { "<leader>l", group = " LSP / Code" },
        { "<leader>lg", group = "󰁔 LSP Go" },
        { "<leader>lt", group = "󰔡 LSP Toggles" },
        { "<leader>lw", group = "󰖲 Workspace" },
        { "<leader>m", group = "󰯈 Multicursor" },
        { "<leader>mc", group = "󰯈 Multicursor" },
        { "<leader>p", group = "󰐃 Plugins / Toggles" },
        { "<leader>q", group = "󰗼 Quit / Write" },
        { "<leader>r", group = "󰑕 Replace" },
        { "<localleader>r", group = " Rust" },
        { "<leader>S", group = "󰆓 Sessions" },
        { "<leader>s", group = "󰿅 Seek / Leap" },
        { "<leader>t", group = " Terminal / Tabs / Tools" },
        { "<leader>td", group = " Todos" },
        { "<leader>w", group = "󰖲 Windows" },
        { "<leader><leader>", group = "󰘳 Quick Actions" },
        { "<leader>z", group = "󰓆 Spelling" },
      })
    end

    -- MiniSnippets maps <C-j> to manual snippet expansion by default. Completion
    -- navigation owns <C-j>/<C-k>/<C-l>; snippets use Tab/S-Tab after expansion.
    pcall(vim.keymap.del, "i", "<C-j>")
    pcall(vim.keymap.del, "s", "<C-j>")

    local function completion_or_snippet_next()
      local ok_cmp, cmp = pcall(require, "blink.cmp")
      if ok_cmp and cmp.is_menu_visible() then
        cmp.select_next()
        return ""
      end

      local ok_snippets = pcall(require, "mini.snippets")
      if ok_snippets and MiniSnippets.session.get() ~= nil then
        MiniSnippets.session.jump("next")
        return ""
      end

      if vim.snippet and vim.snippet.active({ direction = 1 }) then
        vim.snippet.jump(1)
        return ""
      end

      return "\t"
    end

    local function completion_or_snippet_prev()
      local ok_cmp, cmp = pcall(require, "blink.cmp")
      if ok_cmp and cmp.is_menu_visible() then
        cmp.select_prev()
        return ""
      end

      local ok_snippets = pcall(require, "mini.snippets")
      if ok_snippets and MiniSnippets.session.get() ~= nil then
        MiniSnippets.session.jump("prev")
        return ""
      end

      if vim.snippet and vim.snippet.active({ direction = -1 }) then
        vim.snippet.jump(-1)
        return ""
      end

      return vim.keycode("<S-Tab>")
    end

    vim.keymap.set({ "i", "s" }, "<Tab>", completion_or_snippet_next, { expr = true, desc = "Next completion or snippet jump" })
    vim.keymap.set({ "i", "s" }, "<S-Tab>", completion_or_snippet_prev, { expr = true, desc = "Previous completion or snippet jump" })

    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = true,
      severity_sort = true,
    })
  '';
}
