-- Require every *.lua file in a directory, in sorted order.
--   files("apps", "hypr.lyric.apps")   relative dirs resolve inside ~/.config/hypr/lyric
--   files("/abs/dir", nil)             absolute dir already on package.path
local M = {}

local here = os.getenv("HOME") .. "/.config/hypr/lyric/"

function M.files(dir, module_prefix, options)
  if dir:sub(1, 1) ~= "/" then
    dir = here .. dir
  end
  local quoted = "'" .. dir:gsub("'", "'\\''") .. "'"
  local handle = io.popen("find " .. quoted .. " -maxdepth 1 -type f -name '*.lua' -printf '%f\\n' 2>/dev/null | sort")
  if not handle then
    return
  end
  for filename in handle:lines() do
    local module = filename:gsub("%.lua$", "")
    if module_prefix then
      module = module_prefix .. "." .. module
    end
    if options and options.reload then
      package.loaded[module] = nil
    end
    require(module)
  end
  handle:close()
end

return M
