-- Hyprland Lua config.

local colors = {
	shadow = 0xff282c34,
}

local opacity = {
	solid = "1.0 override 1.0 override",
	solid_fullscreen = "1.0 override 1.0 override 1.0 override",
	dim_tool = "0.85 override 0.85 override",
}

local function centered_float(opts)
	opts.float = true
	opts.center = true
	hl.window_rule(opts)
end

local terminal = "uwsm app -- ghostty"
local file_manager = "uwsm app -- ghostty -e yazi"
local editor = "uwsm app -- emacsclient --create-frame --alternate-editor=emacs"
local browser = "uwsm app -- brave"
local menu = "~/.config/scripts/launcher-toggle"
local clipboard = "~/.config/scripts/clipboard-toggle"
local snip = "grimblast copy area"
local reload_shell = "systemctl --user restart quickshell"
-- MSI Bravo 15 C7V internal touchpad from `hyprctl devices`.
-- Future host portability target: move this into a Nix option.
local touchpad_device = "pnp0c50:0b-06cb:7e7e-touchpad"
local touchpad_enabled = true

local function toggle_touchpad()
	touchpad_enabled = not touchpad_enabled
	hl.device({ name = touchpad_device, enabled = touchpad_enabled })
end

hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@144",
	position = "0x0",
	scale = 1,
	bitdepth = 10,
	sdr_eotf = "gamma22",
	sdrbrightness = 0.7,
	sdrsaturation = 1.11,
	supports_wide_color = 1,
	sdr_min_luminance = 0.001,
	sdr_max_luminance = 400,
	vrr = 1,
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "3440x1440@100",
	position = "1920x0",
	scale = 1,
	bitdepth = 10,
	cm = "hdr",
	sdrbrightness = 0.6,
	sdrsaturation = 1.15,
	supports_wide_color = 1,
	supports_hdr = 1,
	sdr_min_luminance = 0.001,
	sdr_max_luminance = 450,
	vrr = 1,
})

hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm finalize HYPRLAND_INSTANCE_SIGNATURE")
	hl.exec_cmd("uwsm app -- vesktop -m")
	hl.exec_cmd("uwsm app -- wl-paste --type text --watch cliphist store")
	hl.exec_cmd("uwsm app -- wl-paste --type image --watch cliphist store")
	hl.exec_cmd("uwsm app -- wl-clip-persist --clipboard regular")
end)

hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 1,
		border_size = 0,
		resize_on_border = false,
		allow_tearing = false,
		layout = "master",
	},

	decoration = {
		rounding = 10,
		rounding_power = 10,
		active_opacity = 1.0,
		inactive_opacity = 0.80,

		blur = {
			enabled = true,
			size = 7,
			passes = 2,
			noise = 0.01,
			contrast = 0.8,
			vibrancy = 0.1696,
			new_optimizations = true,
			ignore_opacity = true,
		},

		shadow = {
			enabled = false,
			range = 1,
			render_power = 6,
			color = colors.shadow,
			color_inactive = colors.shadow,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		mfact = 0.65,
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},

	input = {
		kb_layout = "us",
		follow_mouse = 1,
		sensitivity = 0,
		repeat_rate = 67,
		repeat_delay = 210,

		touchpad = {
			natural_scroll = true,
		},
	},

	cursor = {
		inactive_timeout = 30,
		no_hardware_cursors = true,
	},
})

hl.curve("smoothOut", { type = "bezier", points = { { 0.36, 0 }, { 0.66, -0.56 } } })
hl.curve("smoothIn", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("softSnap", { type = "bezier", points = { { 0.4, 0 }, { 0.2, 1.0 } } })
hl.curve("fluent", { type = "bezier", points = { { 0.0, 0.0 }, { 0.2, 1.0 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "overshot", style = "popin 80%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "overshot", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "smoothOut", style = "popin 95%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "softSnap" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "smoothIn", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2, bezier = "softSnap", style = "fade" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "smoothIn" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 4, bezier = "smoothIn" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 4, bezier = "smoothOut" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 4, bezier = "smoothIn" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 4, bezier = "smoothIn" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 4, bezier = "smoothIn" })
hl.animation({ leaf = "fadeDpms", enabled = true, speed = 4, bezier = "smoothIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "overshot", style = "slidefade 30%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "overshot", style = "slidefadevert 30%" })

local main_mod = "CTRL + ALT"

hl.bind(main_mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(main_mod .. " + T", hl.dsp.exec_cmd(editor))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(main_mod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + S", hl.dsp.exec_cmd(snip))
hl.bind(main_mod .. " + X", hl.dsp.exec_cmd(clipboard))
hl.bind(main_mod .. " + R", hl.dsp.exec_cmd(reload_shell))
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(main_mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + M", hl.dsp.exec_cmd("uwsm stop"))
hl.bind(main_mod .. " + SHIFT + Return", hl.dsp.layout("swapwithmaster master ignoremaster"))
hl.bind(main_mod .. " + SHIFT + D", hl.dsp.exec_cmd("ghostty --title=tmux_main -e tmux new -A -s dots"))

hl.bind(main_mod .. " + SHIFT + l ", hl.dsp.layout("rollnext master ignoremaster"))
hl.bind(main_mod .. " + SHIFT + h ", hl.dsp.layout("rollprev master ignoremaster"))

hl.bind(main_mod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(main_mod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(main_mod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(main_mod .. " + j", hl.dsp.focus({ direction = "d" }))

for workspace = 1, 10 do
	local key = workspace % 10
	hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
	hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(main_mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/scripts/osd-volume up"), { locked = true, repeating = true })
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("~/.config/scripts/osd-volume down"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/scripts/osd-volume mute"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("qs ipc call media playPause"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("~/.config/scripts/osd-mic"), { locked = true })
hl.bind("code:202", toggle_touchpad, { locked = true })
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("~/.config/scripts/osd-brightness up"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("~/.config/scripts/osd-brightness down"),
	{ locked = true, repeating = true }
)

hl.window_rule({
	name = "multimedia_opaque",
	match = { tag = "multimedia_video" },
	no_blur = true,
	opacity = opacity.solid_fullscreen,
})

hl.window_rule({
	name = "global_behavior",
	match = { class = "^.*$" },
	suppress_event = "maximize",
	idle_inhibit = "fullscreen",
})

centered_float({
	name = "floating_pickers",
	match = {
		title = "^(.*Open File.*|.*Open Folder.*|.*Open.*|.*Save.*|.*Save As.*|.*Export.*|.*Import.*|.*Choose File.*|.*Rename.*|.*script-fu.*|.*Authentication Required.*)$",
		class = "^(.*xdg-desktop-portal-gtk.*|.*xdg-desktop-portal-hyprland.*)$",
	},
	size = { 800, 450 },
})

centered_float({
	name = "steam_friends",
	match = { class = "^Steam$", title = "^(Friends List)$" },
	size = { 450, 800 },
})

hl.window_rule({
	name = "firefox",
	match = { class = "^(firefox)$" },
	opacity = opacity.solid_fullscreen,
})

hl.window_rule({
	name = "brave-browser",
	match = { class = "^(brave-browser)$" },
	opacity = opacity.solid_fullscreen,
})

centered_float({
	name = "nvtop_float",
	match = { title = "^(nvtop_float)$" },
	size = { 1000, 600 },
	opacity = opacity.dim_tool,
})

centered_float({
	name = "btop_float",
	match = { title = "^(btop_float)$" },
	size = { 1000, 600 },
	opacity = opacity.solid,
})

centered_float({
	name = "bluetooth_applet",
	match = { title = "^(bluetui)$" },
	size = { 600, 600 },
	opacity = opacity.solid,
})

centered_float({
	name = "wifi_applet",
	match = { title = "^(nmtui|wlctl)$" },
	size = { 600, 600 },
	opacity = opacity.solid,
})

centered_float({
	name = "sound_applet",
	match = { title = "^(wiremix)$" },
	size = { 700, 500 },
	opacity = opacity.solid,
})

hl.layer_rule({
	name = "qs_bar_blur",
	match = { namespace = "^qs-bar$" },
	blur = true,
	ignore_alpha = 0,
})

hl.layer_rule({
	name = "qs_osd_fade",
	match = { namespace = "^qs-osd$" },
	animation = "fade",
})

hl.layer_rule({
	name = "qs_launcher_blur",
	match = { namespace = "^qs-launcher$" },
	blur = true,
	ignore_alpha = 0,
})

hl.layer_rule({
	name = "qs_clipboard_blur",
	match = { namespace = "^qs-clipboard$" },
	blur = true,
	ignore_alpha = 0,
})

hl.layer_rule({
	name = "qs_wallpaper_picker_blur",
	match = { namespace = "^qs-wallpaper-picker$" },
	blur = true,
	ignore_alpha = 0,
})
