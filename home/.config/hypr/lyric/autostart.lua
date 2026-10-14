-- Session services started with Hyprland.
hl.on("hyprland.start", function()
  hl.exec_cmd("systemctl --user import-environment $(env | cut -d'=' -f 1)")
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  hl.exec_cmd(o.launch("udiskie --automount --no-notify --no-tray"))
end)
