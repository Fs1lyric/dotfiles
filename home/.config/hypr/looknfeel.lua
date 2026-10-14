-- Personal look'n'feel, on top of hypr/lyric/looknfeel.lua.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- hl.config({
--   decoration = {
--     -- Use round window corners.
--     rounding = 8,
--
--     -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
--     dim_inactive = true,
--     dim_strength = 0.15,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })

-- Black mica: every window is see-through over a heavy, darkened blur of the wallpaper.
-- xray blurs only the wallpaper (not the windows stacked behind), which is what makes it mica.
-- Lower brightness = blacker glass; raise the opacity numbers if text gets hard to read.
hl.config({
  decoration = {
    blur = {
      enabled = true,
      size = 8,
      passes = 3,
      noise = 0.015,
      contrast = 1.0,
      brightness = 0.80,
      vibrancy = 0.20,
      xray = false,
      new_optimizations = true,
    },
  },
})
-- "active inactive": focused windows a touch more solid than unfocused ones.
-- Targets the default-opacity tag plus browsers, so the apps the defaults keep solid
-- (mpv, vlc, imv, Steam and its games, RetroArch, PiP, qemu, DaVinci, OBS...) stay solid.
o.window({ tag = "default-opacity" }, { opacity = "0.85 0.80" })
o.window({ tag = "chromium-based-browser" }, { opacity = "0.85 0.80" })
o.window({ tag = "firefox-based-browser" }, { opacity = "0.85 0.80" })
-- Terminals: window stays fully opaque so text is crisp; kitty makes only its background see-through.
o.window({ tag = "terminal" }, { opacity = "1 1" })
-- Vesktop draws its own see-through background (system24 theme), so keep the window itself opaque.
o.window("^vesktop$", { opacity = "1 1" })
-- Video web apps and other games stay solid.
o.window("(^.+-youtube\\.com__.*$|^.+-app\\.zoom\\.us__wc_home.*$|^gamescope$|^steam_app_.*$|^lutris$|^heroic$)", { tag = "-default-opacity", opacity = "1 1" })
hl.layer_rule({ match = { namespace = "nwg-dock" }, blur = true, ignore_alpha = 0.05 })

-- macOS windows: rounded corners, a soft deep shadow, a hairline border
-- (its color comes from the macOS Glass theme) and roomier gaps.
hl.config({
  general = {
    gaps_in = 6,
    gaps_out = 12,
    border_size = 1,
  },
  decoration = {
    rounding = 12,
    rounding_power = 2.4,
    shadow = {
      enabled = true,
      range = 40,
      render_power = 3,
      offset = { 0, 12 },
      color = "rgba(00000099)",
      color_inactive = "rgba(00000059)",
    },
  },
})

-- macOS motion: windows grow in from the middle, spaces slide sideways.
hl.curve("macSpring", { type = "bezier", points = { { 0.32, 0.72 }, { 0, 1 } } })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.5, bezier = "macSpring", style = "popin 90%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3.5, bezier = "macSpring" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "macSpring", style = "slide" })
