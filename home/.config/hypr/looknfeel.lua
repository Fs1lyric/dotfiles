-- Change the default Omarchy look'n'feel.

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

-- Liquid glass: blur what sits behind the dock, top bar, menus and notifications.
-- Blur is switched on globally but turned off for every window, so only these layers get it.
hl.config({
  decoration = {
    blur = {
      enabled = true,
      size = 10,
      passes = 3,
      noise = 0.02,
      contrast = 1.0,
      brightness = 1.0,
      vibrancy = 0.3,
    },
  },
})
o.window({ class = ".*" }, { no_blur = true })
hl.layer_rule({ match = { namespace = "nwg-dock" }, blur = true, ignore_alpha = 0.05 })
for _, namespace in ipairs({
  "omarchy-bar", "omarchy-menu", "omarchy-notifications", "omarchy-osd",
  "omarchy-polkit", "omarchy-clipboard", "omarchy-emojis", "omarchy-reminders",
}) do
  hl.layer_rule({ match = { namespace = namespace }, blur = true, ignore_alpha = 0.05 })
end

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
