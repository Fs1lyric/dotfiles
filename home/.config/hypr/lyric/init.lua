-- Hyprland defaults. Personal overrides live next door in
-- ~/.config/hypr/*.lua and are loaded after this.
require("hypr.lyric.helpers")
require("hypr.lyric.autostart")
require("hypr.lyric.require_all").files("bindings", "hypr.lyric.bindings")
require("hypr.lyric.envs")
require("hypr.lyric.looknfeel")
require("hypr.lyric.input")
require("hypr.lyric.windows")
require("hypr.lyric.theme")
