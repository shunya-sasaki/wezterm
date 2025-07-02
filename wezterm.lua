local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

config.color_scheme = "Tokyo Night"
config.window_background_opacity = 0.8

config.initial_cols = 80
config.initial_rows = 30

-- Set the default shell based on the target platform
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "powershell.exe" }
	config.font_size = 12
elseif wezterm.target_triple == "aarch64-apple-darwin" then
	config.default_prog = { "/bin/zsh" }
	config.font_size = 14
else
	config.default_prog = { "/bin/bash" }
	config.font_size = 14
end

wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "|",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({
			domain = "CurrentPaneDomain",
		}),
	},
	{
		key = "a",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			timeout_milliseconds = 1000,
			one_shot = false,
		}),
	},
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({
			domain = "CurrentPaneDomain",
		}),
	},
	{
		key = "t",
		mods = "LEADER",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	-- Activate pane
	{
		key = "h",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	-- Activate tab relative to current
	{
		key = "[",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "]",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(1),
	},
	-- Activate copy mode
	{
		key = "v",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
	-- Paste from clipboard
	{
		key = "p",
		mods = "LEADER",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end
config.key_tables = {
	resize_pane = {
		{
			key = "h",
			mods = "SHIFT",
			action = wezterm.action.AdjustPaneSize({ "Left", 1 }),
		},
		{
			key = "l",
			mods = "SHIFT",
			action = wezterm.action.AdjustPaneSize({ "Right", 1 }),
		},
		{
			key = "k",
			mods = "SHIFT",
			action = wezterm.action.AdjustPaneSize({ "Up", 1 }),
		},
		{
			key = "j",
			mods = "SHIFT",
			action = wezterm.action.AdjustPaneSize({ "Down", 1 }),
		},
	},
}

return config
