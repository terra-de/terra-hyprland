-- log.lua — Minimal file-based logger for terra-hyprland
--
-- Writes to: ~/.local/share/terra/hyprland.log
-- Usage:
--   local log = require("log")
--   log.info("message")
--   log.error("something went wrong")
--   log.debug("verbose detail")
--
-- Zero dependencies. Uses only os.date(), io.open(), os.getenv(), os.execute().

local HOME = os.getenv("HOME")
local LOGDIR = HOME and (HOME .. "/.local/share/terra")
local LOGFILE = LOGDIR and (LOGDIR .. "/hyprland.log")

-- Ensure the log directory exists (no-op if it already does)
if LOGDIR then
  os.execute("mkdir -p " .. LOGDIR)
end

local M = {}

local function append(level, msg)
  if not LOGFILE then return end
  local f = io.open(LOGFILE, "a")
  if f then
    f:write(os.date("%H:%M:%S") .. " [" .. level .. "] " .. msg .. "\n")
    f:close()
  end
end

function M.info(msg)   append("INFO",   msg) end
function M.error(msg)  append("ERROR",  msg) end
function M.debug(msg)  append("DEBUG",  msg) end
function M.warn(msg)   append("WARN",   msg) end

return M
