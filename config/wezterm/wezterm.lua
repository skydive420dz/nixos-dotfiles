local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

local sky = {
  bg = "#1a1d21",
  panel = "#22262b",
  panel_alt = "#282c34",
  fg = "#f0efeb",
  muted = "#8b929c",
  border = "#3d424a",
  accent = "#b4c0c8",
  accent_alt = "#8fb6ff",
  bar_bg = "rgba(26,29,33,0.88)",
  selection = "#3b4350",
  selection_fg = "#f0efeb",
  black = "#1a1d21",
  red = "#df6f72",
  green = "#8fbf8f",
  yellow = "#d9b56f",
  blue = "#8fb6ff",
  magenta = "#c49ad9",
  cyan = "#7fc7d9",
  white = "#f0efeb",
  bright_black = "#5d6672",
  bright_red = "#ef8b8e",
  bright_green = "#a6d7a6",
  bright_yellow = "#e7c77f",
  bright_blue = "#a7c7ff",
  bright_magenta = "#d9b2eb",
  bright_cyan = "#98d9e6",
  bright_white = "#ffffff",
}

local function basename(path)
  return (path or ""):gsub("(.*[/\\])(.*)", "%2")
end

local function dirname_from_uri(uri)
  if not uri then
    return "~"
  end

  local path = tostring(uri)
  if uri.file_path then
    path = uri.file_path
  end

  path = path:gsub("^file://[^/]*", "")
  path = path:gsub("^" .. (os.getenv("HOME") or ""), "~")
  return basename(path)
end

local function push_text(segments, bg, fg, text, intensity)
  table.insert(segments, { Background = { Color = bg } })
  table.insert(segments, { Foreground = { Color = fg } })
  if intensity then
    table.insert(segments, { Intensity = intensity })
  end
  table.insert(segments, { Text = text })
  return wezterm.column_width(text)
end

local function workspace_prompt()
  return act.PromptInputLine({
    description = wezterm.format({
      { Foreground = { Color = sky.accent } },
      { Text = "Switch/create workspace: " },
    }),
    action = wezterm.action_callback(function(window, pane, line)
      if line and line ~= "" then
        window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
      end
    end),
  })
end

wezterm.on("update-right-status", function(window, pane)
  local mode = ""
  if window:leader_is_active() then
    mode = " prefix "
  elseif window:active_key_table() then
    mode = " " .. window:active_key_table() .. " "
  end

  local workspace = window:active_workspace()
  local cwd = dirname_from_uri(pane:get_current_working_dir())
  local user = os.getenv("USER") or "user"
  local host = os.getenv("HOSTNAME") or "nixos"

  local left_segments = {}
  local left_width = 0
  left_width = left_width + push_text(left_segments, sky.bar_bg, sky.muted, "  " .. workspace .. " ")
  left_width = left_width + push_text(left_segments, sky.bar_bg, sky.fg, cwd .. "  ")

  local right_width = wezterm.column_width((mode ~= "" and mode or "") .. "  " .. user .. "   " .. host .. " ")
  local cols = pane:get_dimensions().cols or 120
  local tabs_count = 1
  local ok, tabs = pcall(function()
    return window:mux_window():tabs_with_info()
  end)
  if ok and tabs and #tabs > 0 then
    tabs_count = #tabs
  end

  if ok then
	    tabs = nil
  end

  local tabs_width = tabs_count * 3
  local target = math.max(0, math.floor((cols - tabs_width) / 2))
  local gap = math.max(1, target - left_width)

  table.insert(left_segments, { Background = { Color = sky.bar_bg } })
  table.insert(left_segments, { Foreground = { Color = sky.muted } })
  table.insert(left_segments, { Text = string.rep(" ", gap) })

  local used_width = left_width + gap + tabs_width
  local max_left_width = math.max(0, cols - right_width - 1)
  if used_width > max_left_width then
    local trim = used_width - max_left_width
    if gap > trim then
      left_segments[#left_segments] = { Text = string.rep(" ", gap - trim) }
    end
  end

  window:set_left_status(wezterm.format(left_segments))

  local right_segments = {}
  if mode ~= "" then
    push_text(right_segments, sky.bar_bg, sky.accent, mode, "Bold")
  end
  push_text(right_segments, sky.bar_bg, sky.muted, "  " .. user .. "   " .. host .. "  ")
  window:set_right_status(wezterm.format(right_segments))
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, tab_config, hover, max_width)
  local index = (tab.tab_index or 0) + 1

  local bg = sky.bar_bg
  local fg = sky.muted
  local text = " " .. index .. " "

  if tab.is_active then
    bg = sky.accent
    fg = sky.bg
  elseif hover then
    bg = sky.bar_bg
    fg = sky.muted
  end

  local formatted = {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
  }

  if tab.is_active then
    table.insert(formatted, { Intensity = "Bold" })
  end
  table.insert(formatted, { Text = text })

  return formatted
end)

config.automatically_reload_config = true
config.check_for_updates = false
config.enable_wayland = true

config.font = wezterm.font_with_fallback({
  "JetBrainsMono Nerd Font",
  "Symbols Nerd Font Mono",
})
config.font_size = 12

config.window_decorations = "NONE"
config.window_background_opacity = 0.88
config.text_background_opacity = 1.0
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

config.default_cursor_style = "SteadyBlock"
config.force_reverse_video_cursor = true
config.hide_mouse_cursor_when_typing = true
config.audible_bell = "Disabled"
config.scrollback_lines = 100000
config.pane_focus_follows_mouse = false
config.swallow_mouse_click_on_pane_focus = true
config.quick_select_alphabet = "arstneioqwfpbjluy;zxcdvkm"

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.status_update_interval = 500
config.tab_max_width = 3
config.show_close_tab_button_in_tabs = false
config.show_tab_index_in_tab_bar = false
config.window_frame = {
  font = wezterm.font_with_fallback({
    "JetBrainsMono Nerd Font",
    "Symbols Nerd Font Mono",
  }),
  font_size = 12,
  active_titlebar_bg = sky.bar_bg,
  inactive_titlebar_bg = sky.bar_bg,
}

config.leader = {
  key = "Space",
  mods = "CTRL",
  timeout_milliseconds = 2000,
}

config.launch_menu = {
  { label = "Shell", args = { os.getenv("SHELL") or "zsh" } },
  { label = "Neovim", args = { "nvim" } },
  { label = "Yazi", args = { "yazi" } },
  { label = "Emacs terminal client", args = { "emacsclient", "-nw" } },
}

config.colors = {
  foreground = sky.fg,
  background = sky.bg,
  cursor_bg = sky.accent,
  cursor_fg = sky.bg,
  cursor_border = sky.accent,
  selection_bg = sky.selection,
  selection_fg = sky.selection_fg,
  scrollbar_thumb = sky.border,
  split = sky.border,
  ansi = {
    sky.black,
    sky.red,
    sky.green,
    sky.yellow,
    sky.blue,
    sky.magenta,
    sky.cyan,
    sky.white,
  },
  brights = {
    sky.bright_black,
    sky.bright_red,
    sky.bright_green,
    sky.bright_yellow,
    sky.bright_blue,
    sky.bright_magenta,
    sky.bright_cyan,
    sky.bright_white,
  },
  tab_bar = {
    background = sky.bar_bg,
    active_tab = {
      bg_color = sky.accent,
      fg_color = sky.bg,
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = sky.bar_bg,
      fg_color = sky.muted,
    },
    inactive_tab_hover = {
      bg_color = sky.bar_bg,
      fg_color = sky.muted,
    },
    new_tab = {
      bg_color = sky.bar_bg,
      fg_color = sky.muted,
    },
    new_tab_hover = {
      bg_color = sky.bar_bg,
      fg_color = sky.muted,
    },
  },
}

config.keys = {
  { key = "Space", mods = "LEADER", action = act.SendKey({ key = "Space", mods = "CTRL" }) },

  { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
  { key = ":", mods = "LEADER|SHIFT", action = act.ActivateCommandPalette },
  {
    key = "?",
    mods = "LEADER|SHIFT",
    action = act.ShowLauncherArgs({ flags = "FUZZY|KEY_ASSIGNMENTS|COMMANDS" }),
  },

  { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "n", mods = "LEADER", action = act.SpawnWindow },
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "X", mods = "LEADER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
  { key = "Tab", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "Backspace", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "1", mods = "LEADER", action = act.ActivateTab(0) },
  { key = "2", mods = "LEADER", action = act.ActivateTab(1) },
  { key = "3", mods = "LEADER", action = act.ActivateTab(2) },
  { key = "4", mods = "LEADER", action = act.ActivateTab(3) },
  { key = "5", mods = "LEADER", action = act.ActivateTab(4) },
  { key = "6", mods = "LEADER", action = act.ActivateTab(5) },
  { key = "7", mods = "LEADER", action = act.ActivateTab(6) },
  { key = "8", mods = "LEADER", action = act.ActivateTab(7) },
  { key = "9", mods = "LEADER", action = act.ActivateLastTab },

  { key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "o", mods = "LEADER", action = act.PaneSelect({ mode = "Activate", alphabet = "arstneio" }) },
  { key = "O", mods = "LEADER|SHIFT", action = act.PaneSelect({ mode = "SwapWithActive", alphabet = "arstneio" }) },
  { key = "R", mods = "LEADER|SHIFT", action = act.RotatePanes("Clockwise") },

  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "H", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "J", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "K", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "L", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
  {
    key = "e",
    mods = "LEADER",
    action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false, timeout_milliseconds = 3000 }),
  },

  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "/", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },
  { key = "f", mods = "LEADER", action = act.QuickSelect },
  { key = "y", mods = "LEADER", action = act.CopyTo("Clipboard") },
  { key = "p", mods = "LEADER", action = act.PasteFrom("Clipboard") },

  {
    key = "w",
    mods = "LEADER",
    action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
  },
  { key = "W", mods = "LEADER|SHIFT", action = workspace_prompt() },
  {
    key = "a",
    mods = "LEADER",
    action = act.ShowLauncherArgs({ flags = "FUZZY|TABS|WORKSPACES|LAUNCH_MENU_ITEMS|COMMANDS" }),
  },
}

config.key_tables = {
  resize_pane = {
    { key = "Escape", action = act.PopKeyTable },
    { key = "q", action = act.PopKeyTable },
    { key = "h", action = act.AdjustPaneSize({ "Left", 2 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 2 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 2 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 2 }) },
    { key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 2 }) },
    { key = "DownArrow", action = act.AdjustPaneSize({ "Down", 2 }) },
    { key = "UpArrow", action = act.AdjustPaneSize({ "Up", 2 }) },
    { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 2 }) },
  },
}

return config
