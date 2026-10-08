-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Hold SUPER and drag a window to pop it out of tiling; it stays floating where you drop it.
-- SUPER + T (Omarchy default) snaps it back into the tiles. New apps still open tiled.
-- Unbind existing SUPER + LMB (was: move window within the tiles)
hl.unbind("SUPER + mouse:272")
-- Two binds on one key, run top to bottom: float the window first, then hand it to the drag.
hl.bind("SUPER + mouse:272", hl.dsp.window.float({ action = "set" }), { non_consuming = true, description = "Pop window out of tiling" })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Drag window" })
