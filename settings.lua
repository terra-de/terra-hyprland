-- Diagnostic — if this env var is set, settings.lua was found and started
hl.env("TERRA_DIAG_SETTINGS", "1_loaded")

-- settings.lua — JSON-driven settings loader for terra-hyprland
--
-- Reads two JSON config files and deep-merges them:
--   1. ~/.config/terra/hyprland/preferences.json  (shared/personal)
--   2. ~/.config/terra/hyprland/machine.json      (machine-specific)
--
-- Merge order (last wins):
--   DEFAULTS < preferences.json < machine.json
--
-- Arrays are concatenated (machine appended to preferences).
-- Tables (objects) are recursively deep-merged.
-- Scalar values from machine override preferences override defaults.
--
-- Usage:
--   local settings = require("settings")
--   settings.general.gaps_in     -- 6
--   settings.env.XCURSOR_THEME   -- "Bibata-Modern-Classic"
--   settings.monitors            -- from machine.json (or empty)
--   settings.programs.terminal   -- program path

-- ====================================================================
-- DEFAULT SETTINGS  — mirrors current terra-hyprland hardcoded values
-- ====================================================================
local DEFAULTS = {
  version = 1,

  -- Cursor
  cursor = {
    theme = "Bibata-Modern-Classic",
    size = 24,
    no_hardware_cursors = true,
  },

  -- General behaviour
  general = {
    border_size = 0,
    gaps_in = 6,
    gaps_out = 12,
    gaps_workspaces = 6,
    layout = "dwindle",
    no_focus_fallback = false,
    resize_on_border = true,
    extend_border_grab_area = 15,
    allow_tearing = false,
    resize_corner = 0,
  },

  -- Decoration / appearance
  decoration = {
    rounding = 16,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    fullscreen_opacity = 1.0,
    shadow = {
      enabled = true,
      range = 30,
      render_power = 3,
      sharp = false,
      color = "rgba(00000050)",
      offset = { x = 1, y = 1 },
      scale = 1.0,
    },
    dim = {
      inactive = true,
      strength = 0.1,
      special = 0.1,
      around = 0.4,
    },
    blur = {
      enabled = false,
      size = 8,
      passes = 3,
      ignore_opacity = true,
      new_optimizations = true,
      xray = false,
      noise = 0.07,
      contrast = 1.2,
      brightness = 1.7,
      vibrancy = 0.8,
      vibrancy_darkness = 0.4,
      special = false,
      popups = true,
      popups_ignorealpha = 0.2,
    },
  },

  -- Animation toggle
  animations = {
    enabled = true,
  },

  -- Misc Hyprland settings
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = false,
    disable_splash_rendering = true,
    initial_workspace_tracking = 0,
    enable_anr_dialog = false,
  },

  -- Dwindle layout
  dwindle = {
    preserve_split = true,
    force_split = 2,
    precise_mouse_move = true,
  },

  -- Input
  input = {
    kb_layout = "us",
    numlock_by_default = true,
    accel_profile = "flat",
    scroll_method = "2fg",
    follow_mouse = 1,
    special_fallthrough = false,
    sensitivity = 0,
    touchpad = {
      disable_while_typing = true,
      natural_scroll = true,
      scroll_factor = 0.7,
    },
    tablet = {
      output = "current",
    },
  },

  -- Touchpad gestures
  gestures = {
    workspace_swipe_distance = 300,
    workspace_swipe_touch = true,
    workspace_swipe_invert = true,
    workspace_swipe_min_speed_to_force = 5,
    workspace_swipe_cancel_ratio = 0.5,
    workspace_swipe_direction_lock = false,
    workspace_swipe_forever = true,
  },

  -- Bezier curves for animations
  bezier_curves = {
    bounce = {
      type = "bezier",
      points = { { 0.38, 1.21 }, { 0.22, 1.0 } },
    },
    ["smooth-in"] = {
      type = "bezier",
      points = { { 0.3, 0.0 }, { 0.8, 0.15 } },
    },
  },

  -- Per-leaf animation entries
  animation_entries = {
    windows =             { enabled = true,  speed = 3,   bezier = "bounce",    style = "slide" },
    windowsOut =          { enabled = true,  speed = 3,   bezier = "bounce",    style = "slide" },
    layers =              { enabled = true,  speed = 2,   bezier = "bounce",    style = "slide top" },
    layersOut =           { enabled = true,  speed = 2,   bezier = "smooth-in", style = "slide top" },
    workspaces =          { enabled = true,  speed = 3.5, bezier = "bounce",    style = "slide" },
    specialWorkspace =    { enabled = true,  speed = 3,   bezier = "bounce",    style = "slidevert" },
    specialWorkspaceOut = { enabled = true,  speed = 2,   bezier = "smooth-in", style = "slidevert" },
  },

  -- Gesture specs (for hl.gesture calls)
  gesture_specs = {
    { fingers = 4, direction = "horizontal", action = "workspace" },
    { fingers = 3, direction = "left",   action = "tctl", command = "gesture left" },
    { fingers = 3, direction = "right",  action = "tctl", command = "gesture right" },
    { fingers = 3, direction = "up",     action = "tctl", command = "gesture up" },
    { fingers = 3, direction = "down",   action = "tctl", command = "gesture down" },
  },

  -- Environment variables
  env = {
    XCURSOR_THEME = "Bibata-Modern-Classic",
    XCURSOR_SIZE = "24",
    XDG_CURRENT_DESKTOP = "Hyprland",
    ELECTRON_OZONE_PLATFORM_HINT = "auto",
    QT_QPA_PLATFORMTHEME = "qt6ct",
    QT_QPA_PLATFORM = "wayland",
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1",
    GDK_USE_PORTAL = "1",
    GTK_ICON_THEME = "material-actions",
  },

  -- Autostart commands (simple strings — terrashell + setcursor are handled in hyprland.lua)
  autostart = {
    "systemctl --user start hyprpolkitagent",
    "awww-daemon",
    "/bin/kdeconnectd",
    "wl-paste --watch cliphist store",
    "hyprsunset",
    "cd ~/.config/matugen/materialized-web && uv run app.py",
  },

  -- Program paths  (overridable in preferences.json)
  programs = {
    terminal = "foot zellij-session-picker",
    quickterm = "foot zellij attach -c quickterm",
    file_manager = "dolphin",
    browser = "firefox",
  },

  -- Key modifier aliases  (used by binds.lua)
  keys = {
    modifiers = {
      main  = "SUPER",
      mut   = "SHIFT",
      scope = "CTRL",
      sys   = "ALT",
    },
    leader = "SUPER + SPACE",
  },

  -- Window rules
  window_rules = {
    suppress_maximize = true,
    fullscreen_classes = { "steam_app*", "factorio*", "Terraria*" },
    additional = {},
  },

  -- Layer rules
  layer_rules = {
    no_anim_namespaces = { "^quickshell(.*)?$", "selection" },
    animation_overrides = {
      { namespace = "wvkbd", animation = "slide bottom" },
    },
  },

  -- Workspace rules
  workspace_rules = {
    {
      workspace = "special:quickterm",
      gaps_out = { top = 150, left = 30, bottom = 0, right = 30 },
    },
  },

  -- Machine-specific (filled by machine.json; empty by default)
  monitors = {},
}

-- Quick pre-require log (in case log.lua itself doesn't load)
-- ~/.local/share/terra/hyprland.log

local log_ok, log = pcall(require, "log")
if not log_ok then
  -- If log.lua can't load, create a fallback logger
  log = { info = function() end, error = function() end, debug = function() end, warn = function() end }
end

log.info("=== settings.lua loaded ===")

-- ====================================================================
-- INLINE JSON DECODER
--
-- Converts JSON (`:`) to Lua table syntax (`=`) by scanning
-- character-by-character, only replacing colons outside of strings.
-- Handles escaped quotes (`\"`) inside strings correctly.
-- ====================================================================

-- JSON-to-Lua converter:
--   • Quoted strings followed by `:` are keys — wrapped as `key=` or `["key"]=`
--   • JSON arrays `[...]` become Lua tables `{...}`
--   • Strings containing ':' are left untouched
local function to_lua(s)
  local out = {}
  local i = 1
  while i <= #s do
    local c = s:sub(i, i)
    if c == '"' and (i == 1 or s:sub(i - 1, i - 1) ~= '\\') then
      -- Quoted string — find its end
      local start = i
      local j = i + 1
      while j <= #s do
        local c2 = s:sub(j, j)
        if c2 == '"' and s:sub(j - 1, j - 1) ~= '\\' then
          local key_str = s:sub(start, j)
          -- Look ahead for ':'
          local k = j + 1
          while k <= #s and s:sub(k, k):match("%s") do k = k + 1 end
          if k <= #s and s:sub(k, k) == ':' then
            -- This is a JSON key
            local bare_key = s:sub(start + 1, j - 1)
            if bare_key:match("^[%a_][%w_]*$") then
              out[#out + 1] = bare_key .. "="
            else
              out[#out + 1] = "[" .. key_str .. "]="
            end
            i = k + 1  -- skip ':'
          else
            -- This is a value string — output as-is
            out[#out + 1] = key_str
            i = j + 1
          end
          break
        end
        j = j + 1
      end
      if j > #s then
        out[#out + 1] = s:sub(start)
        i = #s + 1
      end
    elseif c == '[' then
      -- JSON array → Lua table
      out[#out + 1] = '{'
      i = i + 1
    elseif c == ']' then
      out[#out + 1] = '}'
      i = i + 1
    else
      out[#out + 1] = c
      i = i + 1
    end
  end
  return table.concat(out)
end

local function parse_json(s)
  local converted = to_lua(s)
  local fn, err = load("return " .. converted, "=settings.json", "t", {})
  if not fn then
    log.debug("parse_json: load failed: " .. tostring(err))
    log.debug("parse_json: first 200 chars: " .. converted:sub(1, 200))
    return nil, err
  end
  local ok, result = pcall(fn)
  if not ok then
    log.debug("parse_json: execution error: " .. tostring(result))
    return nil, result
  end
  return result
end

-- ====================================================================
-- FILE READER
-- ====================================================================

local function read_json_file(path)
  if not path then
    log.debug("read_json_file: no path")
    return nil, "no path"
  end
  local f, err = io.open(path, "r")
  if not f then
    log.debug("read_json_file: cannot open " .. path .. " (" .. tostring(err) .. ")")
    return nil, err
  end
  local content = f:read("*a")
  f:close()
  if not content or content == "" then
    log.debug("read_json_file: " .. path .. " is empty")
    return nil, "empty file"
  end
  local data, parse_err = parse_json(content)
  if not data then
    log.debug("read_json_file: parse error in " .. path .. " — " .. tostring(parse_err))
    return nil, parse_err
  end
  log.debug("read_json_file: " .. path .. " parsed OK (" .. #content .. " bytes)")
  return data
end

-- ====================================================================
-- DEEP MERGE
-- ====================================================================

--- Deep-merge `overlay` into `base`, returning a new table.
--- - Tables (objects) are recursively merged.
--- - Arrays (sequential integer keys) are concatenated (overlay appended to base).
--- - Scalar values from overlay replace base.
local function deep_merge(base, overlay)
  local result = {}
  -- Copy base first
  for k, v in pairs(base) do
    result[k] = v
  end
  -- Apply overlay
  for k, v in pairs(overlay) do
    local base_v = base[k]
    if type(v) == "table" and type(base_v) == "table" then
      -- Detect arrays by checking for sequential integer keys
      local base_is_array = #base_v > 0
      local overlay_is_array = #v > 0
      if base_is_array or overlay_is_array then
        -- Array: concatenate (overlay items appended to base items)
        result[k] = {}
        for _, item in ipairs(base_v) do
          table.insert(result[k], item)
        end
        for _, item in ipairs(v) do
          table.insert(result[k], item)
        end
      else
        -- Object: recursive deep merge
        result[k] = deep_merge(base_v, v)
      end
    else
      -- Scalar or type mismatch: overlay wins
      result[k] = v
    end
  end
  return result
end

-- ====================================================================
-- LOAD & MERGE
-- ====================================================================

local home = os.getenv("HOME")
local config_dir = home and (home .. "/.config/terra/hyprland")

log.info("HOME=" .. tostring(home))
log.info("config_dir=" .. tostring(config_dir))

local settings

if config_dir then
  -- 1. Load preferences.json
  local prefs_path = config_dir .. "/preferences.json"
  log.info("Reading " .. prefs_path .. "...")
  local prefs = read_json_file(prefs_path)
  if prefs then
    local kc = 0
    for _ in pairs(prefs) do kc = kc + 1 end
    log.info("  preferences.json: OK (" .. kc .. " top-level keys)")
  else
    log.info("  preferences.json: not found or parse error — using empty")
    prefs = {}
  end

  -- 2. Load machine.json
  local machine_path = config_dir .. "/machine.json"
  log.info("Reading " .. machine_path .. "...")
  local machine = read_json_file(machine_path)
  if machine then
    local kc = 0
    for _ in pairs(machine) do kc = kc + 1 end
    log.info("  machine.json: OK (" .. kc .. " top-level keys)")
    if machine.monitors then
      log.info("  machine.json has " .. #machine.monitors .. " monitor(s)")
    end
  else
    log.info("  machine.json: not found or parse error — using empty")
    machine = {}
  end

  -- 3. Merge: DEFAULTS < prefs < machine
  log.info("Merging DEFAULTS + preferences.json...")
  settings = deep_merge(DEFAULTS, prefs)
  log.info("Merging + machine.json...")
  settings = deep_merge(settings, machine)

  local kc = 0
  for _ in pairs(settings) do kc = kc + 1 end
  log.info("Settings merge complete: " .. kc .. " top-level keys")
  log.info("monitors in final settings: " .. tostring(#settings.monitors) .. " entries")
else
  log.info("No config_dir (HOME not set), using DEFAULTS only")
  settings = DEFAULTS
end

return settings
