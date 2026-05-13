-- utils.lua — Binding system for terra-hyprland
--
-- Provides:
--   M.dsp       — Proxy that mirrors hl.dsp and records calls for serialization
--   M.set_binds — Register bindings from pattern + dispatcher tuples
--   M.flush     — Write keys.json + prefix map for which-key
--
-- Pattern syntax:
--   "<main-h>"                → chord "SUPER + h" (immediate)
--   "<main-mut-H>"            → chord "SUPER + SHIFT + H"
--   "<leader>y"               → chord "SUPER + SPACE" + seq "y" (which-key)
--   "<XF86MonBrightnessDown>" → literal key name
--   "<space>"                 → "SPACE"
--   "<main-mouse:272>"        → "SUPER + mouse:272"
--
-- Aliases (defined in mods.lua):
--   main  → SUPER   mut  → SHIFT   scope → CTRL   sys → ALT
--   leader → SUPER + SPACE  (and any custom aliases)

local M = {}

-- ---------------------------------------------------------------------------
-- Load aliases from mods.lua
-- ---------------------------------------------------------------------------

local aliases = {}
local mods_ok, mods = pcall(require, "mods")
if mods_ok and type(mods.aliases) == "table" then
  for k, v in pairs(mods.aliases) do
    aliases[k] = v
  end
end

-- ---------------------------------------------------------------------------
-- Dev path — overridable via env var
-- ---------------------------------------------------------------------------

local TCTL_PATH = os.getenv("TCTL_PATH") or "tctl"

-- ---------------------------------------------------------------------------
-- dsp proxy — mirrors hl.dsp, records calls into a queue
-- ---------------------------------------------------------------------------

local call_queue = {}  -- queue of { path = "hl.dsp.focus", args = { ... } }
local queue_head = 0
local queue_tail = 0

local function queue_push(val)
  queue_tail = queue_tail + 1
  call_queue[queue_tail] = val
end

local function queue_pop()
  if queue_head >= queue_tail then
    return nil
  end
  queue_head = queue_head + 1
  return call_queue[queue_head]
end

-- Build recursive proxy that mirrors hl.dsp shape
local function make_proxy(path_parts)
  return setmetatable({}, {
    __index = function(_, key)
      local child = {}
      for _, p in ipairs(path_parts) do
        child[#child + 1] = p
      end
      child[#child + 1] = key

      -- Walk real hl.dsp to check if this is a function or sub-table
      local real = hl.dsp
      for _, p in ipairs(child) do
        if type(real) == "table" then
          real = real[p]
        else
          real = nil
          break
        end
      end

      if type(real) ~= "function" then
        return make_proxy(child)
      end

      return function(...)
        local path_str = "hl.dsp." .. table.concat(child, ".")
        local result = real(...)
        queue_push({ path = path_str, args = { ... }, result = result })
        return result
      end
    end,
  })
end

M.dsp = make_proxy({})

-- ---------------------------------------------------------------------------
-- Pattern parser
-- ---------------------------------------------------------------------------

-- Returns: chords (resolved strings), seq (bare char keys)
-- Example: "<main-mut-h>ab" → { "SUPER + SHIFT + h" }, { "a", "b" }
local function parse_pattern(pattern)
  local chords = {}
  local seq = {}
  local i = 1
  while i <= #pattern do
    local c = pattern:sub(i, i)
    if c == "<" then
      local close = pattern:find(">", i)
      if not close then
        error("utils: unclosed < in pattern '" .. pattern .. "'")
      end
      local inner = pattern:sub(i + 1, close - 1)
      i = close + 1

      local parts = {}
      for part in inner:gmatch("[^-]+") do
        parts[#parts + 1] = part
      end
      if #parts == 0 then
        error("utils: empty <> in pattern '" .. pattern .. "'")
      end

      local resolved = {}
      for _, p in ipairs(parts) do
        local alias_val = aliases[p:lower()]
        if alias_val then
          for word in alias_val:gmatch("%S+") do
            resolved[#resolved + 1] = word
          end
        else
          resolved[#resolved + 1] = p:upper()
        end
      end
      chords[#chords + 1] = table.concat(resolved, " + ")
    else
      local ch = c:lower()
      if ch ~= " " then
        seq[#seq + 1] = ch
      end
      i = i + 1
    end
  end
  return chords, seq
end

-- ---------------------------------------------------------------------------
-- Lua value serializer (→ Lua source code string)
-- ---------------------------------------------------------------------------

local function serialize_lua(val)
  local t = type(val)
  if t == "string" then
    return string.format("%q", val)
  elseif t == "number" or t == "boolean" then
    return tostring(val)
  elseif t == "table" then
    local is_array = (#val > 0)
    local parts = {}
    if is_array then
      for _, v in ipairs(val) do
        parts[#parts + 1] = serialize_lua(v)
      end
      return "{ " .. table.concat(parts, ", ") .. " }"
    else
      local keys = {}
      for k in pairs(val) do
        keys[#keys + 1] = k
      end
      table.sort(keys)
      for _, k in ipairs(keys) do
        parts[#parts + 1] = k .. " = " .. serialize_lua(val[k])
      end
      return "{ " .. table.concat(parts, ", ") .. " }"
    end
  else
    return "nil"
  end
end

-- ---------------------------------------------------------------------------
-- JSON serializer (→ JSON string)
-- ---------------------------------------------------------------------------

local function serialize_json(val, indent)
  indent = indent or ""
  local t = type(val)
  if t == "string" then
    local escaped = val:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '\\r'):gsub('\t', '\\t')
    return '"' .. escaped .. '"'
  elseif t == "number" then
    if val % 1 == 0 then
      return tostring(val)
    end
    return tostring(val)
  elseif t == "boolean" then
    return tostring(val)
  elseif t == "table" then
    return serialize_json_table(val, indent)
  else
    return "null"
  end
end

local function serialize_json_table(t, indent)
  local next_indent = indent .. "  "
  -- Detect array
  local is_array = true
  for k in pairs(t) do
    if type(k) ~= "number" or k < 1 or math.floor(k) ~= k or k > #t then
      is_array = false
      break
    end
  end
  if is_array then
    if #t == 0 then
      return "[]"
    end
    local parts = {}
    for _, v in ipairs(t) do
      parts[#parts + 1] = next_indent .. serialize_json(v, next_indent)
    end
    return "[\n" .. table.concat(parts, ",\n") .. "\n" .. indent .. "]"
  else
    local keys = {}
    for k in pairs(t) do
      keys[#keys + 1] = k
    end
    table.sort(keys)
    if #keys == 0 then
      return "{}"
    end
    local parts = {}
    for _, k in ipairs(keys) do
      parts[#parts + 1] = next_indent .. serialize_json(k, next_indent) .. ": " .. serialize_json(t[k], next_indent)
    end
    return "{\n" .. table.concat(parts, ",\n") .. "\n" .. indent .. "}"
  end
end

-- ---------------------------------------------------------------------------
-- Global state built across all set_binds calls
-- ---------------------------------------------------------------------------

local wk_entries = {}        -- array of { keys, description, command }
local prefix_map = {}        -- chord → which-key path array
local registered_chords = {} -- set: chords already registered via hl.bind

-- ---------------------------------------------------------------------------
-- set_binds — two-pass: first collect, then register
-- ---------------------------------------------------------------------------

function M.set_binds(binds)
  -- ---- Pass 1: collect entry info, detect prefixes ----

  local entries = {}  -- { pattern, chords, seq, call_info, opts }
  local first_chord_counts = {}  -- first_chord → count

  for idx, entry in ipairs(binds) do
    local pattern = entry[1]
    local opts = entry[3] or {}

    local chords, seq = parse_pattern(pattern)
    if #chords == 0 then
      goto skip_entry
    end

    local call_info = queue_pop()
    local first_chord = chords[1]

    entries[#entries + 1] = {
      pattern = pattern,
      chords = chords,
      seq = seq,
      call_info = call_info,
      opts = opts,
      first_chord = first_chord,
    }

    first_chord_counts[first_chord] = (first_chord_counts[first_chord] or 0) + 1

    ::skip_entry::
  end

  -- Determine which first chords are prefixes
  -- A chord is a prefix if it appears more than once OR has trailing segments
  local is_prefix = {}
  for _, e in ipairs(entries) do
    local has_trailing = #e.chords > 1 or #e.seq > 0
    if has_trailing or (first_chord_counts[e.first_chord] or 0) > 1 then
      is_prefix[e.first_chord] = true
    end
  end

  -- ---- Pass 2: register binds + build which-key data ----

  for _, e in ipairs(entries) do
    local first_chord = e.first_chord
    local call_info = e.call_info
    local opts = e.opts
    local is_immediate = (#e.chords == 1 and #e.seq == 0)

    local lua_str = nil
    if call_info then
      local args_strs = {}
      for _, arg in ipairs(call_info.args) do
        args_strs[#args_strs + 1] = serialize_lua(arg)
      end
      lua_str = call_info.path .. "(" .. table.concat(args_strs, ", ") .. ")"
    end

    if is_immediate and not is_prefix[first_chord] then
      -- Standalone immediate bind
      if not registered_chords[first_chord] then
        hl.bind(first_chord, call_info and call_info.result or e.opts, opts)
        registered_chords[first_chord] = true
      end
    else
      -- Prefix bind — register first chord as tctl keys trigger
      if not registered_chords[first_chord] then
        hl.bind(first_chord, hl.dsp.exec_cmd(TCTL_PATH .. " keys " .. first_chord))
        registered_chords[first_chord] = true
      end

      -- Build which-key path from trailing chords + seq
      local wk_path = {}
      for ci = 2, #e.chords do
        wk_path[#wk_path + 1] = e.chords[ci]:lower()
      end
      for _, sk in ipairs(e.seq) do
        wk_path[#wk_path + 1] = sk
      end

      -- Store in prefix map (first chord → wk_path)
      prefix_map[first_chord] = wk_path

      -- Store which-key leaf entry
      if lua_str then
        local full_keys = table.concat(wk_path, "")
        local desc = opts.desc or first_chord
        -- Use hyprctl eval for runtime dispatch
        local command = "hyprctl eval 'hl.dispatch(" .. lua_str .. ")'"
        wk_entries[#wk_entries + 1] = {
          keys = full_keys,
          description = desc,
          command = command,
        }
      end
    end
  end
end

-- ---------------------------------------------------------------------------
-- flush — write keys.json + prefix map at end of config load
-- ---------------------------------------------------------------------------

function M.flush()
  local home = os.getenv("HOME")
  if not home then
    return
  end

  local terra_dir = home .. "/.config/terra"
  os.execute("mkdir -p " .. terra_dir)

  if #wk_entries > 0 then
    local f, err = io.open(terra_dir .. "/keys.json", "w")
    if f then
      f:write(serialize_json(wk_entries))
      f:write("\n")
      f:close()
    end
  end

  local pm_keys = {}
  for k in pairs(prefix_map) do
    pm_keys[#pm_keys + 1] = k
  end
  if #pm_keys > 0 then
    local f, err = io.open(terra_dir .. "/binds-prefix-map.json", "w")
    if f then
      f:write(serialize_json(prefix_map))
      f:write("\n")
      f:close()
    end
  end
end

return M
