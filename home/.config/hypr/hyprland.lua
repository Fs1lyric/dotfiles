-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Modules load from ~/.config (hypr.*). Drop them from the cache so
-- `hyprctl reload` picks up edits.
local home = os.getenv("HOME")
for module in pairs(package.loaded) do
  if module == "hypr" or module:sub(1, 5) == "hypr." then
    package.loaded[module] = nil
  end
end
package.path = home .. "/.config/?.lua;" .. package.path

-- Defaults: keybindings, look and feel, window rules, theme (~/.config/hypr/lyric).
require("hypr.lyric.init")

-- Personal overrides, loaded after the defaults.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")
require("hypr.titlebars")

-- Runtime toggles (gaps, aspect ratio) and per-workspace layouts.
require("hypr.lyric.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })
