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
-- SCHEMA LOADING  (replaces hardcoded DEFAULTS table)
--
-- Loads settings-schema.json, strips metadata ($-prefixed keys),
-- then flattens category wrappers to produce the DEFAULTS table.
-- ====================================================================

--- Recursively strip all $-prefixed metadata keys from the schema.
--- - Objects with $default resolve to that scalar value.
--- - Objects with $defaults resolve to that value (recursively stripped).
--- - Otherwise recurses into non-$ children.
local function strip_meta(v)
  if type(v) ~= "table" then return v end
  if v["$default"] ~= nil then return v["$default"] end
  if v["$defaults"] ~= nil then return strip_meta(v["$defaults"]) end
  local result = {}
  for k, val in pairs(v) do
    if type(k) ~= "string" or k:sub(1, 1) ~= "$" then
      result[k] = strip_meta(val)
    end
  end
  return result
end

--- Flatten category wrappers: lift all children of category objects
--- up one level. A category wrapper is an object where every non-$
--- child is itself a table (no direct scalar values).
local function flatten_categories(t)
  local result = {}
  for k, v in pairs(t) do
    if type(v) == "table" and type(k) == "string" and k:sub(1, 1) ~= "$" then
      local is_category = true
      for ck, cv in pairs(v) do
        if not (type(ck) == "string" and ck:sub(1, 1) == "$") and type(cv) ~= "table" then
          is_category = false
          break
        end
      end
      if is_category then
        for ck, cv in pairs(v) do
          if not (type(ck) == "string" and ck:sub(1, 1) == "$") then
            result[ck] = cv
          end
        end
      else
        result[k] = v
      end
    else
      result[k] = v
    end
  end
  return result
end

--- Resolve schema file path relative to this Lua file's location.
--- Uses debug.getinfo to find where settings.lua was loaded from,
--- then appends the schema filename. Works in any directory layout.
local function resolve_schema_path()
  local info = debug.getinfo(1, "S")
  if info and info.source and info.source:sub(1, 1) == "@" then
    local filepath = info.source:sub(2)
    local dir = filepath:match("^(.*/)")
    if dir then
      return dir .. "settings-schema.json"
    end
  end
  -- Last-resort fallback if debug info is unavailable
  return "/usr/share/terra/hyprland/settings-schema.json"
end

-- Load and process schema to produce DEFAULTS
local schema_file = resolve_schema_path()
if not schema_file then
  error("settings-schema.json not found")
end

local raw_schema = read_json_file(schema_file)
if not raw_schema then
  error("Failed to parse settings-schema.json")
end

local DEFAULTS = flatten_categories(strip_meta(raw_schema))

log.info("Schema loaded from: " .. schema_file)
do
  local kc = 0
  for _ in pairs(DEFAULTS) do kc = kc + 1 end
  log.info("DEFAULTS from schema: " .. kc .. " top-level keys")
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
