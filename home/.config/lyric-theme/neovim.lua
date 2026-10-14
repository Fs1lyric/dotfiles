return {
  {
    "bjarneo/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg = "#1c1c1e",
        dark_bg = "#121212",
        darker_bg = "#000000",
        lighter_bg = "#2c2c2e",

        fg = "#e5e5ea",
        dark_fg = "#8e8e93",
        light_fg = "#f2f2f7",
        bright_fg = "#ffffff",
        muted = "#48484a",

        red = "#ff453a",
        yellow = "#ffd60a",
        orange = "#ff9f0a",
        green = "#30d158",
        cyan = "#64d2ff",
        blue = "#0a84ff",
        magenta = "#bf5af2",
        brown = "#ac8e68",

        bright_red = "#ff6961",
        bright_yellow = "#ffe066",
        bright_green = "#5fe07c",
        bright_cyan = "#8ae0ff",
        bright_blue = "#409cff",
        bright_magenta = "#da8fff",

        accent = "#0a84ff",
        cursor = "#ffffff",
        foreground = "#e5e5ea",
        background = "#1c1c1e",
        selection = "#3a3a3c",
        selection_foreground = "#ffffff",
        selection_background = "#3a3a3c",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
  },
}
