package.path = package.path .. ";" .. os.getenv("HOME") .. "/.cache/wal/?.lua"

local ok, pywal = pcall(require, "colors")
if not ok then
	hl.exec_cmd("notify-send 'Hyprland' 'Failed to load Pywal colors'")
	pywal = {
		special = { background = "#1e1e2e", foreground = "#cdd6f4", cursor = "#cdd6f4" },
		colors = {
			color0 = "#1e1e2e",
			color1 = "#f38ba8",
			color2 = "#a6e3a1",
			color3 = "#f9e2af",
			color4 = "#89b4fa",
			color5 = "#cba6f7",
			color6 = "#94e2d5",
			color7 = "#bac2de",
			color8 = "#585b70",
			color9 = "#f38ba8",
			color10 = "#a6e3a1",
			color11 = "#f9e2af",
			color12 = "#89b4fa",
			color13 = "#cba6f7",
			color14 = "#94e2d5",
			color15 = "#cdd6f4",
		},
	}
end

local bg = pywal.special.background
local fg = pywal.special.foreground
local c0 = pywal.colors.color0
local c1 = pywal.colors.color1
local c2 = pywal.colors.color2
local c3 = pywal.colors.color3
local c4 = pywal.colors.color4
local c5 = pywal.colors.color5
local c6 = pywal.colors.color6
local c7 = pywal.colors.color7
local c8 = pywal.colors.color8
local c9 = pywal.colors.color9
local c10 = pywal.colors.color10
local c11 = pywal.colors.color11
local c12 = pywal.colors.color12
local c13 = pywal.colors.color13
local c14 = pywal.colors.color14
local c15 = pywal.colors.color15

hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
	general = {
		col = {
			active_border = { colors = { c4, c5, c6 } },
			inactive_border = "rgba(00000000)",
		},
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		hover_icon_on_border = true,
		resize_corner = 2,
		layout = "dwindle",
	},
	decoration = {
		rounding = 0,
		active_opacity = 0.92,
		inactive_opacity = 0.8,
		fullscreen_opacity = 1.0,
		blur = {
			enabled = true,
			size = 12,
			passes = 3,
			ignore_opacity = false,
			new_optimizations = true,
			xray = true,
			noise = 0.03,
			contrast = 0.65,
			brightness = 1.0,
			vibrancy = 0.35,
			vibrancy_darkness = 0.0,
		},
		shadow = {
			enabled = true,
			range = 20,
			render_power = 3,
			scale = 0.98,
			color = "rgba(00000077)",
			offset = { 0, 4 },
		},
	},
	animations = {
		enabled = true,
		bezier = {
			{ name = "wind", points = { 0.05, 0.9, 0.1, 1.05 } },
			{ name = "winIn", points = { 0.1, 1.1, 0.1, 1.1 } },
			{ name = "winOut", points = { 0.3, -0.3, 0, 1 } },
			{ name = "liner", points = { 0, 0, 1, 1 } },
		},
		animation = {
			{ name = "windows", style = "wind", duration = 2, curve = "wind" },
			{ name = "windowsIn", style = "winIn", duration = 2, curve = "winIn" },
			{ name = "windowsOut", style = "winOut", duration = 2, curve = "winOut" },
			{ name = "windowsMove", style = "wind", duration = 2, curve = "wind" },
			{ name = "fade", style = "fade", duration = 2, curve = "liner" },
			{ name = "fadeDim", style = "fade", duration = 2, curve = "liner" },
			{ name = "border", style = "border", duration = 2, curve = "liner" },
			{ name = "borderangle", style = "border", duration = 2, curve = "liner" },
			{ name = "workspaces", style = "wind", duration = 2, curve = "wind" },
		},
	},
	input = {
		kb_layout = "us,ara",
		kb_options = "grp:alt_shift_toggle",
		kb_variant = "",
		kb_model = "",
		follow_mouse = 1,
		mouse_refocus = true,
		accel_profile = "",
		sensitivity = 0,
		numlock_by_default = true,
		force_no_accel = false,
		float_switch_override_focus = 2,
		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			scroll_factor = 1.0,
		},
	},
	cursor = {
		no_hardware_cursors = true,
	},
	dwindle = {
		preserve_split = true,
		force_split = 2,
		special_scale_factor = 0.8,
		split_width_multiplier = 1.0,
		smart_split = false,
		smart_resizing = false,
		permanent_direction_override = true,
	},
	master = {
		special_scale_factor = 0.8,
		mfact = 0.55,
		orientation = "center",
		new_on_top = true,
		allow_small_split = true,
		drop_at_cursor = false,
	},
	misc = {
		disable_autoreload = false,
		enable_swallow = true,
		swallow_regex = "",
		swallow_exception_regex = "",
		focus_on_activate = true,
		always_follow_on_dnd = true,
		animate_mouse_windowdragging = false,
		disable_splash_rendering = false,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = false,
		disable_hyprland_logo = true,
		vrr = 0,
	},
	binds = {
		allow_workspace_cycles = true,
		ignore_group_lock = false,
		workspace_back_and_forth = true,
		movefocus_cycles_fullscreen = false,
		scroll_event_delay = 300,
	},
	debug = {
		damage_blink = false,
		disable_logs = true,
		disable_time = false,
	},
})

hl.monitor({
	output = "DP-1",
	mode = "1920x1080@120",
	position = "0x0",
	scale = "1",
})

hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@120",
	position = "1920x0",
	scale = "1",
})

hl.workspace_rule({
	workspace = "1",
	monitor = "DP-1",
	default = true,
})

hl.workspace_rule({
	workspace = "2",
	monitor = "DP-1",
})

hl.workspace_rule({
	workspace = "3",
	monitor = "DP-1",
})

hl.workspace_rule({
	workspace = "4",
	monitor = "DP-1",
})

hl.workspace_rule({
	workspace = "5",
	monitor = "DP-1",
})

hl.workspace_rule({
	workspace = "6",
	monitor = "eDP-1",
})

hl.workspace_rule({
	workspace = "7",
	monitor = "eDP-1",
})

hl.workspace_rule({
	workspace = "8",
	monitor = "eDP-1",
})

hl.workspace_rule({
	workspace = "9",
	monitor = "eDP-1",
})

hl.workspace_rule({
	workspace = "10",
	monitor = "eDP-1",
})

local mainMod = "SUPER"

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("kitty -e yazi"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("rofi -show run"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("clipboard"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.window.move({ into_group = "l" }))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("audio-switcher"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(mainMod .. " + N", hl.dsp.group.toggle())
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.move({ out_of_group = true }))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("killall waybar; sleep 0.2 && waybar"))
hl.bind(mainMod .. " + grave", hl.dsp.exec_cmd("scratchpad"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("record-screen"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("web-search"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("kitty --class=nmtui -e nmtui"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("quick-notes"))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("rofi -show emoji"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -a"))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }), { repeating = true })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }), { repeating = true })
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }), { repeating = true })
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }), { repeating = true })

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "l" }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "r" }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }), { repeating = true })

hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot -m window"))

hl.window_rule({
	match = { class = "vesktop" },
	workspace = "5",
})

hl.window_rule({
	match = { class = "vesktop" },
	group = "bar",
})

hl.window_rule({
	match = { class = "obsidian" },
	workspace = "3",
})

hl.window_rule({
	match = { class = "copyq" },
	float = true,
})

hl.window_rule({
	match = { class = "pavucontrol" },
	float = true,
})

hl.window_rule({
	match = { class = "blueman-manager" },
	float = true,
})

hl.window_rule({
	match = { class = "org.gnome.Calculator" },
	float = true,
})

hl.window_rule({
	match = { class = "org.gnome.Nautilus" },
	float = true,
})

hl.window_rule({
	match = { class = "thunar" },
	float = true,
})

hl.window_rule({
	match = { class = "imv" },
	float = true,
})

hl.window_rule({
	match = { class = "mpv" },
	float = true,
})

hl.window_rule({
	match = { title = "zen-beta — Zen Browser" },
	workspace = "2",
})

hl.window_rule({
	match = { title = ".* — Mozilla Firefox" },
	workspace = "2",
})

hl.window_rule({
	match = { title = "picture in picture" },
	float = true,
	pin = true,
})

hl.window_rule({
	match = { class = "scratchpad" },
	workspace = "special:scratchpad",
	float = true,
})

hl.window_rule({
	match = { class = "notes" },
	float = true,
})

hl.window_rule({
	match = { class = "nmtui" },
	float = true,
})

hl.layer_rule({
	match = { namespace = "waybar" },
	order = 0,
	no_anim = true,
	blur = true,
})

hl.layer_rule({
	match = { namespace = "swaync-control-center" },
	blur = true,
	ignore_alpha = 0,
	order = 1,
})

hl.layer_rule({
	match = { namespace = "swaync-notification-window" },
	blur = true,
	ignore_alpha = 0,
	order = 1,
})

hl.layer_rule({
	match = { namespace = "copyq" },
	order = 9999,
})

hl.on("hyprland.start", function()
	hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
	hl.exec_cmd("pactl set-card-profile bluez_card.F4_B6_2D_A9_2F_89 a2dp-sink 2>/dev/null")
	hl.exec_cmd("swaync")
	hl.exec_cmd("wl-paste --watch cliphist store &")
	hl.exec_cmd("awww-daemon & sleep 0.5 && awww img " .. pywal.wallpaper .. " --transition-type fade")
	hl.exec_cmd("hypridle")

	hl.exec_cmd("notify-send 'Hyprland' 'Welcome back!'")
end)

hl.on("hyprland.shutdown", function()
	hl.exec_cmd("awww kill")
end)
