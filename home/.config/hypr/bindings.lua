-- Personal keybindings, loaded after the defaults in hypr/lyric/bindings/.
-- See every binding with SUPER + K.
--
-- Add a new binding:
--   o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")
-- Change an existing one by unbinding it first:
--   hl.unbind("SUPER + SPACE")
--   o.bind("SUPER + SPACE", "Menu", "omenu system")

-- Rearrange the bottom dock's icons (arrow keys + Space to move, Enter to save).
o.bind("SUPER + ALT + D", "Arrange dock", "lyric-launch tui --app-id=lyric.terminal dock-arrange")
