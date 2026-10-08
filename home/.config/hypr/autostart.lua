-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- macOS-style dock at the bottom (pins live in ~/.cache/nwg-dock-pinned, style in ~/.config/nwg-dock-hyprland/style.css)
o.launch_on_start("nwg-dock-hyprland -r -x -i 44 -mb 8 -nolauncher -iw special")

-- Re-apply the cursor chosen by the theme (WhiteSur on macOS Glass) at login.
o.exec_on_start([[sh -c 'hyprctl setcursor "$(gsettings get org.gnome.desktop.interface cursor-theme | tr -d \')" 24']])

-- Proton VPN: start in the tray and auto-connect (fastest server, set in ~/.config/Proton/VPN/app-config.json)
o.launch_on_start("protonvpn-app --start-minimized")
