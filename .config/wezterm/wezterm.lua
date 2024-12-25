local wezterm = require 'wezterm';

local config = {}
local act = wezterm.action
local judgeMacOS = wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin"

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Font
config.font = wezterm.font_with_fallback{
    "UDEV Gothic 35NFLG",
    "HackGen35 NF"
}
config.font_size = 13.0


-- Colorscheme and theme
config.color_scheme = "Kanagawa (Gogh)" -- 自分の好きなテーマ探す https://wezfurlong.org/wezterm/colorschemes/index.html
config.window_background_opacity = 0.85
if wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin" then
    config.macos_window_background_blur = 20
elseif wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.win32_system_backdrop = "acrylic"
end
config.show_new_tab_button_in_tab_bar = false

-- keybindings
-- 全部削除して自分で設定する
config.disable_default_key_bindings = true
config.leader = { key="j", mods="CTRL" }
config.keys = {
    -- Pane navigation
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "-", mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain"} },
    { key = "|", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain"} },

    -- Tab navigation
    { key = "c", mods = "LEADER", action = act.SpawnTab("DefaultDomain") },
    { key = "w", mods = "LEADER", action = act.ShowTabNavigator },

    -- Copy mode
    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    { key = "]", mods = "LEADER", action = act.PasteFrom("Clipboard") },
   
    -- Common bindings
    { key = "C", mods = "CTRL", action = act.CopyTo("Clipboard") },
    { key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },

}

-- Other
config.use_ime = true 
config.scrollback_lines = 10000
config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.check_for_updates = false


return config
