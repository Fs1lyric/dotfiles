-- macOS-style traffic lights on every window, via the hyprbars plugin.
-- Install once with: hyprpm add https://github.com/hyprwm/hyprland-plugins && hyprpm enable hyprbars
-- Close (red), minimize (yellow, sends to the scratchpad; SUPER+S brings it back),
-- maximize (green, toggles full width). Double-click the bar to maximize too.

o.launch_on_start("hyprpm reload -n")

if not (hl.plugin and hl.plugin.hyprbars) then
  return
end

local maximize = [[hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })']]

hl.config({
  plugin = {
    hyprbars = {
      bar_height = 28,
      bar_color = "rgba(1c1c1eff)",
      ["col.text"] = "rgb(d1d1d6)",
      bar_text_font = "Inter Medium",
      bar_text_size = 11,
      bar_text_align = "center",
      bar_buttons_alignment = "left",
      bar_padding = 12,
      bar_button_padding = 8,
      bar_part_of_window = true,
      bar_precedence_over_border = true,
      icon_on_hover = true,
      inactive_button_color = "rgb(48484a)",
      on_double_click = maximize,
    },
  },
})

-- Buttons sit on the left like macOS, laid out from the left edge inward in the order
-- they are added: close (red), minimize (yellow), maximize (green).
hl.plugin.hyprbars.add_button({
  bg_color = "rgb(ff5f57)",
  fg_color = "rgb(4d0000)",
  size = 12,
  icon = "×",
  action = "hyprctl dispatch 'hl.dsp.window.close()'",
})
hl.plugin.hyprbars.add_button({
  bg_color = "rgb(febc2e)",
  fg_color = "rgb(5a3c00)",
  size = 12,
  icon = "−",
  action = [[hyprctl dispatch 'hl.dsp.window.move({ workspace = "special:scratchpad", follow = false })']],
})
hl.plugin.hyprbars.add_button({
  bg_color = "rgb(28c840)",
  fg_color = "rgb(004d00)",
  size = 12,
  icon = "+",
  action = maximize,
})
