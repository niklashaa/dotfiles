local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font({ family = "Hack Nerd Font" })
config.font_size = 12

config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

config.hide_tab_bar_if_only_one_tab = true
-- config.enable_tab_bar = false
config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.8

return config
