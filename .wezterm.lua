-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.90

-- and finally, return the configuration to wezterm
config.enable_wayland = true

config.enable_tab_bar = false

config.font_size = 11.0

config.font = wezterm.font 'MonaspiceXe Nerd Font Mono'
config.font_rules = {
  {
    intensity = 'Bold',
    italic = true,
    font = wezterm.font {
      family = 'MonaspiceRn Nerd Font Mono',
      weight = 'Bold',
      style = 'Italic',
    },
  },
  {
    italic = true,
    intensity = 'Half',
    font = wezterm.font {
      family = 'MonaspiceRn Nerd Font Mono',
      weight = 'DemiBold',
      style = 'Italic',
    },
  },
  {
    italic = true,
    intensity = 'Normal',
    font = wezterm.font {
      family = 'MonaspiceRn Nerd Font Mono',
      style = 'Italic',
    },
  },
}

--config.disable_default_key_bindings = true

wezterm.gui.get_appearance()

return config
