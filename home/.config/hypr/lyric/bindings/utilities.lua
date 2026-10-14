-- Menus (omenu), Noctalia panels, capture, notifications and toggles.
local menu = function(section)
  return "omenu" .. (section and (" " .. section) or "")
end

o.bind("SUPER + SPACE", "Menu", menu())
o.bind("SUPER + SHIFT + code:201", "Menu", menu())
o.bind("SUPER + ALT + SPACE", "Apps", menu("apps"))
o.bind("SUPER + CTRL + C", "Capture menu", menu("capture"))
o.bind("SUPER + CTRL + O", "Toggle menu", menu("toggle"))
o.bind("SUPER + ESCAPE", "System menu", menu("system"))
o.bind("XF86PowerOff", "Power menu", "noctalia msg panel-toggle session", { locked = true })
o.bind("SUPER + CTRL + SPACE", "Wallpaper", menu("style"))
o.bind("SUPER + SHIFT + CTRL + SPACE", "Colour scheme", menu("style"))
o.bind("SUPER + K", "Keybindings", "lyric-util keys")
o.bind("SUPER + ALT + K", "Tmux keybindings", "lyric-util tmux-keys")
o.bind("SUPER + CTRL + E", "Emojis", "noctalia msg panel-toggle launcher /emo")
o.bind("SUPER + PERIOD", "Emojis", "noctalia msg panel-toggle launcher /emo")
o.bind("SUPER + SEMICOLON", "Emojis", "noctalia msg panel-toggle launcher /emo")

if o.cmd_present("omacalc") then
  o.bind("SUPER + CTRL + Q", "Calculator", "omacalc")
  o.bind("XF86Calculator", "Calculator", "omacalc")
end

-- Noctalia panels.
o.bind("SUPER + CTRL + A", "Quick settings", "noctalia msg panel-toggle control-center")
o.bind("SUPER + CTRL + B", "Quick settings", "noctalia msg panel-toggle control-center")
o.bind("SUPER + CTRL + W", "Quick settings", "noctalia msg panel-toggle control-center")
o.bind("SUPER + CTRL + ALT + D", "Dashboard", "noctalia msg panel-toggle control-center")
o.bind("SUPER + CTRL + P", "Power", "noctalia msg panel-toggle session")

-- Notifications.
o.bind("SUPER + comma", "Clear notifications", "noctalia msg notification-clear-active")
o.bind("SUPER + SHIFT + comma", "Clear notifications", "noctalia msg notification-clear-active")
o.bind("SUPER + ALT + comma", "Notifications sidebar", "noctalia msg panel-toggle control-center")
o.bind("SUPER + SHIFT + ALT + comma", "Notifications sidebar", "noctalia msg panel-toggle control-center")
o.bind("SUPER + CTRL + comma", "Do not disturb", "noctalia msg notification-dnd-toggle")

-- Window look toggles.
o.bind("SUPER + BACKSPACE", "Toggle window transparency", "lyric-window transparency")
o.bind("SUPER + SHIFT + BACKSPACE", "Toggle window gaps", "lyric-window toggle window-no-gaps")
o.bind("SUPER + CTRL + BACKSPACE", "Toggle single-window square aspect", "lyric-window toggle single-window-aspect-ratio")
o.bind("SUPER + CTRL + I", "Toggle idle lock", "noctalia msg caffeine-toggle")
o.bind("SUPER + CTRL + N", "Toggle nightlight", "lyric-util nightlight")

-- Capture.
o.bind("PRINT", "Screenshot", "noctalia msg screenshot-region")
o.bind("SUPER + SHIFT + PRINT", "Screenshot full screen", "noctalia msg screenshot-fullscreen")
o.bind("ALT + PRINT", "Screen recording", "lyric-record region")
o.bind("SUPER + PRINT", "Color picker", "pkill hyprpicker || hyprpicker -a")
o.bind("SUPER + CTRL + PRINT", "Extract text (OCR) from screenshot", "lyric-util ocr")

-- Reminders and quick info.
o.bind("SUPER + CTRL + R", "Set reminder", "lyric-util remind")
o.bind("SUPER + CTRL + ALT + R", "Show reminders", "lyric-util reminders")
o.bind("SUPER + SHIFT + CTRL + R", "Clear reminders", "lyric-util clear-reminders")
o.bind("SUPER + CTRL + ALT + T", "Show time", "lyric-util time")
o.bind("SUPER + CTRL + ALT + W", "Show weather", "lyric-util weather")

-- Cursor zoom.
o.bind("SUPER + CTRL + Z", "Zoom in", function()
  local zoom = hl.get_config("cursor.zoom_factor") or 1
  hl.config({ cursor = { zoom_factor = zoom + 1 } })
end)
o.bind("SUPER + CTRL + ALT + Z", "Reset zoom", function()
  hl.config({ cursor = { zoom_factor = 1 } })
end)

o.bind("SUPER + CTRL + L", "Lock system", "noctalia msg session lock")
