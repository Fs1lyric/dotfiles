-- Runtime toggles written by lyric-window (gaps, aspect ratio) and per-workspace
-- layouts. Both live in ~/.local/state/lyric and are reloaded on every config reload.
local require_all = require("hypr.lyric.require_all")
local state = (os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")) .. "/lyric"

for _, dir in ipairs({ "toggles", "workspace-layouts" }) do
  local path = state .. "/" .. dir
  package.path = path .. "/?.lua;" .. package.path
  require_all.files(path, nil, { reload = true })
end
