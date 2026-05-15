-- terra-hyprland — Hyprland Lua configuration for Terra DE
-- Installed to /usr/share/terra/hyprland/hyprland.lua
--
-- Launch with: terra-hyprland
--   (runs: start-hyprland -- --config /usr/share/terra/hyprland/hyprland.lua)

-- Ensure module resolution works for files in the same directory
-- package.path = "/usr/share/terra/hyprland/?.lua;" .. package.path

-- ====================================================================
-- ENVIRONMENT VARIABLES
-- ====================================================================

-- Cursor
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")

-- Desktop portal
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

-- Wayland-by-default for apps
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("GDK_USE_PORTAL", "1")

-- Icon theme
hl.env("GTK_ICON_THEME", "material-actions")

-- Path resolution helpers
local utils = require("utils")

-- ====================================================================
-- CONFIGURATION MODULES
-- ====================================================================

require("colors")     -- Color lookup from ~/.config/terra/palette.json
require("config")     -- General, decoration, input, animations, etc.
require("workspaces") -- Special workspace rules
require("binds")      -- All keybindings
require("rules")      -- Window + layer rules

-- ====================================================================
-- MACHINE-SPECIFIC OVERRIDES
-- ====================================================================

-- If ~/.config/hypr/local.lua exists, load it.
-- Users put monitors, per-device tweaks, additional binds here.
-- Example local.lua:
--   hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1.5 })
--   hl.monitor({ output = "", mode = "preferred", position = "auto-left" })
--   hl.device({ name = "syna32c0:00-06cb:ceb0-touchpad", accel_profile = "adaptive" })
--
-- Users can also use the binding system in local.lua:
--   local utils = require("utils")
--   utils.bind_keys({
--     ["main-scope-mut-m"] = { hl.dsp.window.move({ workspace = "special:messages" }), desc = "Move to messages" },
--   })

pcall(dofile, os.getenv("HOME") .. "/.config/hypr/local.lua")

-- ====================================================================
-- AUTOSTART
-- ====================================================================

hl.on("hyprland.start", function()
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd(utils.terrashell_bin())
  hl.exec_cmd("/bin/kdeconnectd")
  hl.exec_cmd("wl-paste --watch cliphist store")
  hl.exec_cmd("hyprsunset")
  hl.exec_cmd("hyprctl setcursor 'Bibata-Modern-Classic' 24")
  hl.exec_cmd("cd ~/.config/matugen/materialized-web && uv run app.py")
end)

-- ====================================================================
-- SUBMAP CHANGE NOTIFICATION  — signal terrashell which-key
-- ====================================================================

hl.on("keybinds.submap", function(name)
  if name and name ~= "" then
    hl.exec_cmd(utils.tctl_bin() .. " keys show " .. name)
  else
    hl.exec_cmd(utils.tctl_bin() .. " keys dismiss")
  end
end)
