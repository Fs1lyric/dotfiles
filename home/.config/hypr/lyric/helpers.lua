-- Global `o` helpers used by every bindings/rules file.

o = o or {}

local function shell_quote(value)
  return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end
o.shell_quote = shell_quote

local function file_exists(path)
  local file = io.open(path, "r")
  if file then
    file:close()
    return true
  end
  return false
end

function o.cmd_present(command)
  local path = os.getenv("PATH") or "/usr/local/bin:/usr/bin"
  for directory in (path .. ":"):gmatch("([^:]*):") do
    if file_exists((directory ~= "" and directory or ".") .. "/" .. command) then
      return true
    end
  end
  return false
end

-- A dispatcher may be a table describing what to launch:
--   { app = "terminal" }                  lyric-launch terminal
--   { launch = "obsidian", focus = "^obsidian$" }
--   { webapp = url, focus = true }        focus the open web app, else open it
--   { tui = "btop", focus = true }
local function command_from(value, description)
  if type(value) ~= "table" then
    return value
  end
  if value.app then
    return "lyric-launch " .. value.app
  elseif value.launch then
    if value.focus then
      return "lyric-launch focus " .. shell_quote(value.focus) .. " " .. o.launch(value.launch)
    end
    return o.launch(value.launch)
  elseif value.webapp then
    if value.focus then
      return "lyric-launch focus-webapp " .. shell_quote(description) .. " " .. shell_quote(value.webapp)
    end
    return "lyric-launch webapp " .. shell_quote(value.webapp)
  elseif value.tui then
    return "lyric-launch " .. (value.focus and "focus-tui " or "tui ") .. shell_quote(value.tui)
  end
  return value
end

function o.bind(keys, description, dispatcher, options)
  local opts = options or {}
  if description then
    opts.description = description
  end
  dispatcher = command_from(dispatcher, description)
  if type(dispatcher) == "string" then
    dispatcher = hl.dsp.exec_cmd(dispatcher)
  end
  hl.bind(keys, dispatcher, opts)
end

function o.launch(command)
  return "uwsm-app -- " .. command
end

function o.exec_on_start(command)
  hl.on("hyprland.start", function()
    hl.exec_cmd(command)
  end)
end

function o.launch_on_start(command)
  o.exec_on_start(o.launch(command))
end

function o.window(match, rules)
  rules.match = rules.match or {}
  if type(match) == "string" then
    rules.match.class = match
  else
    for key, value in pairs(match) do
      rules.match[key] = value
    end
  end
  hl.window_rule(rules)
end
