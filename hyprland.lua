-- terra-hyprland — Hyprland Lua configuration for Terra DE
--
-- Diagnostic checkpoint #1 — before any require() calls.
-- If this env var is set, hyprland.lua is definitely being loaded.
hl.env("TERRA_DIAG", "1_top_of_file")

-- ====================================================================
-- SETTINGS LOADER
-- ====================================================================

hl.env("TERRA_DIAG", "2_before_require_log")
local log = require("log")
hl.env("TERRA_DIAG", "3_after_require_log")

log.info("=== terra-hyprland starting ===")

-- Wrap require() in pcall so a settings failure doesn't kill the session
hl.env("TERRA_DIAG", "4_before_require_settings")
local settings_ok, settings = pcall(require, "settings")
if not settings_ok then
  log.error("require('settings') FAILED: " .. tostring(settings))
  hl.env("TERRA_DIAG", "5_settings_FAILED")
  -- Minimal fallback so hyprland.lua doesn't crash
  settings = {
    env = {},
    autostart = {},
    cursor = { theme = "Bibata-Modern-Classic", size = 24 },
    monitors = {},
  }
else
  hl.env("TERRA_DIAG", "5_settings_OK")
  -- Count top-level keys for diagnostics
  local count = 0
  for _ in pairs(settings) do count = count + 1 end
  log.info("settings loaded: " .. count .. " top-level keys")
  log.info("settings.monitors: " .. tostring(#settings.monitors) .. " entries")
end

hl.env("TERRA_DIAG", "6_before_require_utils")
local utils = require("utils")
hl.env("TERRA_DIAG", "7_after_require_utils")
log.info("utils loaded")

-- ====================================================================
-- ENVIRONMENT VARIABLES  (from settings)
-- ====================================================================

local env_count = 0
for key, value in pairs(settings.env) do
  hl.env(key, value)
  env_count = env_count + 1
  log.debug("  env " .. key .. "=" .. tostring(value))
end
log.info("Set " .. env_count .. " env vars")

-- ====================================================================
-- MONITORS  (from settings / machine.json)
-- ====================================================================

for _, mon in ipairs(settings.monitors) do
  hl.monitor(mon)
  log.debug("  monitor: " .. tostring(mon.output or mon.name or "?"))
end
log.info("Applied " .. tostring(#settings.monitors) .. " monitors")

-- ====================================================================
-- CONFIGURATION MODULES
-- ====================================================================

log.info("Loading colors.lua...")
require("colors")
log.info("Loading config.lua...")
require("config")
log.info("Loading workspaces.lua...")
require("workspaces")
log.info("Loading binds.lua...")
require("binds")
log.info("Loading rules.lua...")
require("rules")
log.info("All modules loaded")

-- ====================================================================
-- MACHINE-SPECIFIC OVERRIDES
-- ====================================================================

pcall(dofile, os.getenv("HOME") .. "/.config/hypr/local.lua")
log.info("local.lua check done")

-- ====================================================================
-- AUTOSTART  (from settings)
-- ====================================================================

hl.on("hyprland.start", function()
  log.info("=== autostart begin ===")

  for _, cmd in ipairs(settings.autostart) do
    hl.exec_cmd(cmd)
    log.debug("  autostart: " .. cmd)
  end

  local ts = utils.terrashell_bin()
  hl.exec_cmd(ts)
  log.info("  autostart: " .. ts)

  local sc = "hyprctl setcursor '" .. settings.cursor.theme .. "' " .. settings.cursor.size
  hl.exec_cmd(sc)
  log.info("  autostart: " .. sc)

  log.info("=== autostart end ===")
end)

-- ====================================================================
-- SUBMAP CHANGE NOTIFICATION
-- ====================================================================

hl.on("keybinds.submap", function(name)
  if name and name ~= "" then
    hl.exec_cmd(utils.tctl_bin() .. " keys show " .. name)
  else
    hl.exec_cmd(utils.tctl_bin() .. " keys dismiss")
  end
end)

log.info("=== terra-hyprland config loading complete ===")
