-- Volume goes through PipeWire and brightness through Noctalia; Noctalia
-- watches PipeWire, so its OSD shows every change either way.
local sink = "@DEFAULT_AUDIO_SINK@"
local volume = function(step)
  return "wpctl set-mute " .. sink .. " 0 && wpctl set-volume -l 1.0 " .. sink .. " " .. step
end
local brightness = function(value)
  return "noctalia msg " .. value
end
local locked_repeat = { locked = true, repeating = true }

o.bind("XF86AudioRaiseVolume", "Volume up", volume("5%+"), locked_repeat)
o.bind("XF86AudioLowerVolume", "Volume down", volume("5%-"), locked_repeat)
o.bind("ALT + XF86AudioRaiseVolume", "Volume up precise", volume("1%+"), locked_repeat)
o.bind("ALT + XF86AudioLowerVolume", "Volume down precise", volume("1%-"), locked_repeat)
o.bind("XF86AudioMute", "Mute", "wpctl set-mute " .. sink .. " toggle", { locked = true })
o.bind("XF86AudioMicMute", "Mute microphone", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", { locked = true })
o.bind("SHIFT + XF86AudioMute", "Switch audio output", "noctalia msg panel-toggle control-center audio", { locked = true })

o.bind("XF86MonBrightnessUp", "Brightness up", brightness("brightness-up 5"), locked_repeat)
o.bind("XF86MonBrightnessDown", "Brightness down", brightness("brightness-down 5"), locked_repeat)
o.bind("ALT + XF86MonBrightnessUp", "Brightness up precise", brightness("brightness-up 1"), locked_repeat)
o.bind("ALT + XF86MonBrightnessDown", "Brightness down precise", brightness("brightness-down 1"), locked_repeat)
o.bind("SHIFT + XF86MonBrightnessUp", "Brightness maximum", brightness("brightness-set 100"), { locked = true })
o.bind("SHIFT + XF86MonBrightnessDown", "Brightness minimum", brightness("brightness-set 1"), { locked = true })

local mpris = {
  { "XF86AudioNext", "Next track", "next" },
  { "ALT + XF86AudioPlay", "Next track", "next" },
  { "XF86AudioPause", "Pause", "toggle" },
  { "XF86AudioPlay", "Play", "toggle" },
  { "XF86AudioPrev", "Previous track", "previous" },
  { "ALT + SHIFT + XF86AudioPlay", "Previous track", "previous" },
}
for _, b in ipairs(mpris) do
  o.bind(b[1], b[2], "noctalia msg media " .. b[3], { locked = true })
end
o.bind("XF86Eject", "Eject media", "eject", { locked = true })
