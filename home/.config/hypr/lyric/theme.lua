-- Colours from the frozen theme (~/.config/lyric-theme).
local theme = os.getenv("HOME") .. "/.config/lyric-theme/"
for _, name in ipairs({ "gum_env.lua", "hyprland.lua", "hyprland-final.lua" }) do
  if io.open(theme .. name, "r") then
    dofile(theme .. name)
  end
end
