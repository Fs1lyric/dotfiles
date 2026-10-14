-- Session environment.
local home = os.getenv("HOME")

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XCOMPOSEFILE", home .. "/.XCompose")

-- ~/.local/bin first (lyric-* helpers and personal overrides).
local user_bin = home .. "/.local/bin"
local path = { user_bin }
for entry in (os.getenv("PATH") or "/usr/local/bin:/usr/bin"):gmatch("[^:]+") do
  if entry ~= user_bin then
    table.insert(path, entry)
  end
end
hl.env("PATH", table.concat(path, ":"))


hl.config({
  xwayland = {
    force_zero_scaling = true,
  },
  ecosystem = {
    no_update_news = true,
  },
})
