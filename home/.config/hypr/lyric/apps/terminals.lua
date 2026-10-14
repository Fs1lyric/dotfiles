-- Define terminal tag so themes and bindings can single terminals out.
-- lyric-launch opens TUIs under lyric.<name> app-ids (lyric.btop, TUI.float, ...),
-- so match those too.
-- The class is matched in full, so foot's other app-id needs spelling out.
o.window(
  "(Alacritty|kitty|com.mitchellh.ghostty|foot|org\\.codeberg\\.dnkl\\.foot|wezterm|lyric\\..*|TUI\\..*)",
  { tag = "+terminal" }
)
