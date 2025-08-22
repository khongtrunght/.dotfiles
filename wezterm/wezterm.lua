local wezterm = require("wezterm")
local io = require("io")
local os = require("os")

-- Background randomization function
local home = os.getenv("HOME")
local background_folder = home .. "/Pictures/terminal_bg"
local brightness = 0.04 -- Current brightness value
local bg_image = home .. "/Pictures/terminal_bg/TangerineFade_Mac.png" -- Track current background
local function pick_random_background(folder)
	local handle = io.popen('ls "' .. folder .. '"')
	if handle ~= nil then
		local files = handle:read("*a")
		handle:close()

		local images = {}
		for file in string.gmatch(files, "[^\n]+") do
			table.insert(images, file)
		end

		if #images > 0 then
			return folder .. "/" .. images[math.random(#images)]
		else
			return nil
		end
	end
end

return {
	-- color_scheme = "termnial.sexy",
	color_scheme = "Tokyo Night",
	enable_tab_bar = true,
	font_size = 16.0,
	font = wezterm.font("JetBrainsMono Nerd Font"),
	-- macos_window_background_blur = 40,
	macos_window_background_blur = 35,
	front_end = "WebGpu",
	-- config.front_end = "WebGpu" -- Use WebGPU for rendering

	window_background_image = "/Users/khongtrunght/Pictures/terminal_bg/TangerineFade_Mac.png",
	window_background_image_hsb = {
		brightness = 0.04,
		hue = 1.0,
		saturation = 0.7,
	},
	-- window_background_opacity = 0.92,
	window_background_opacity = 1.0,
	-- window_background_opacity = 0.78,
	-- window_background_opacity = 0.20,
	window_decorations = "RESIZE",
	keys = {
		{
			key = "f",
			mods = "CTRL",
			action = wezterm.action.ToggleFullScreen,
		},
		{
			key = "'",
			mods = "CTRL",
			action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
		},
		{
			key = "A",
			mods = "CTRL|SHIFT",
			action = wezterm.action.QuickSelect,
		},
		{
			key = "b",
			mods = "CTRL|SHIFT",
			action = wezterm.action_callback(function(window)
				bg_image = pick_random_background(background_folder)
				if bg_image then
					window:set_config_overrides({
						window_background_image = bg_image,
					})
					wezterm.log_info("New background: " .. bg_image)
				else
					wezterm.log_error("Could not find background image")
				end
			end),
		},
		{
			key = ">",
			mods = "CTRL|SHIFT",
			action = wezterm.action_callback(function(window)
				brightness = math.min(brightness + 0.01, 1.0)
				window:set_config_overrides({
					window_background_image_hsb = {
						brightness = brightness,
						hue = 1.0,
						saturation = 0.7,
					},
					window_background_image = bg_image,
				})
			end),
		},
		{
			key = "<",
			mods = "CTRL|SHIFT",
			action = wezterm.action_callback(function(window)
				brightness = math.max(brightness - 0.01, 0.01)
				window:set_config_overrides({
					window_background_image_hsb = {
						brightness = brightness,
						hue = 1.0,
						saturation = 0.7,
					},
					window_background_image = bg_image,
				})
			end),
		},
	},
	mouse_bindings = {
		-- Ctrl-click will open the link under the mouse cursor
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},
}
