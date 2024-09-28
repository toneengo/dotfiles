-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.9

-- and finally, return the configuration to wezterm
config.enable_wayland = true

config.enable_tab_bar = false

config.font_size = 11.0

config.font = wezterm.font 'MonaspiceXe Nerd Font Mono'

wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)

  local zoomed = ''
  if tab.active_pane.is_zoomed then
    zoomed = '[Z] '
  end

  local index = ''
  if #tabs > 1 then
    index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
  end

  return wezterm.truncate_right(tab.active_pane.title, 100)
end)

wezterm.gui.get_appearance()

return config
