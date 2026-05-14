-- utils.lua — Keybinding utilities for terra-hyprland
--
-- Provides bind_keys() which accepts a flat declarative table:
--
--   -- Leaf (always a table: { dispatcher, desc?, icon?, ...flags }):
--   ["main-h"] = { hl.dsp.focus({ direction = "left" }) },
--
--   -- Leaf (with opts flattened):
--   ["main-C"] = { hl.dsp.window.close(), desc = "Close window", icon = "close" },
--
--   -- Submap container:
--   ["main-space"] = {
--     group = "Leader",
--     y = { hl.dsp.workspace.toggle_special("quickterm"), desc = "Quickterm", icon = "terminal" },
--   }
--
-- Modifier aliases (defined in mods.lua):
--   "main"  → "SUPER",  "mut"   → "SHIFT"
--   "scope" → "CTRL",   "sys"   → "ALT"
--
-- Submap naming is automatic: group name slug + parent path.
-- Every submap gets:
--   catchall  → reset (any undefined key closes the submap)
--   escape    → reset (explicit close)
--   backspace → parent submap or reset at root level
-- Leaf binds inside a submap auto-reset to global after dispatching.

local M = {}

-- Load aliases from mods.lua
local aliases = {}
local mods_ok, mods = pcall(require, "mods")
if mods_ok and type(mods.aliases) == "table" then
  for k, v in pairs(mods.aliases) do
    aliases[k] = v
  end
end

-- Resolve a key spec like "main-h" → "SUPER + H"
-- Splits on "-", resolves each part via aliases, rejoins with " + "
local function resolve_key(spec)
  local parts = {}
  for part in spec:gmatch("[^-]+") do
    local alias_val = aliases[part:lower()]
    if alias_val then
      for word in alias_val:gmatch("%S+") do
        parts[#parts + 1] = word
      end
    else
      parts[#parts + 1] = part
    end
  end
  return table.concat(parts, " + ")
end

-- Build hl.bind opts from a flat entry table.
-- Handles desc → description, icon prefixing, and passthrough of flags.
local function build_opts(entry)
  if type(entry) ~= "table" then
    return nil
  end

  local opts = {}
  local desc_str = nil
  local icon_str = nil

  for k, v in pairs(entry) do
    if type(k) == "number" then
      -- skip positional dispatcher (index 1)
    elseif k == "desc" then
      desc_str = v
    elseif k == "icon" then
      icon_str = v
    elseif k == "group" then
      -- handled by caller
    elseif k == "description" then
      -- skip, handled by desc/icon below
    else
      opts[k] = v
    end
  end

  -- Build description with optional icon prefix
  if icon_str or desc_str then
    local parts = {}
    if icon_str then
      parts[#parts + 1] = "<" .. icon_str .. ">"
    end
    if desc_str then
      parts[#parts + 1] = desc_str
    end
    opts.description = table.concat(parts, "")
  end

  -- Only return opts if non-empty
  local has_opts = false
  for _ in pairs(opts) do
    has_opts = true
    break
  end
  return has_opts and opts or nil
end

-- Generate submap slug from group name and parent path slug
-- e.g. ("Leader", nil) → "leader"
--      ("Utilities", "leader") → "leader_utilities"
local function make_slug(group, parent)
  local slug = group:lower():gsub("%s+", "_"):gsub("[^%w_]", "")
  if parent and parent ~= "" then
    return parent .. "_" .. slug
  end
  return slug
end

-- Recursively register binds and submaps.
-- parent_slug is nil for root level, or the enclosing submap's slug.
-- in_submap indicates whether we're inside a submap (triggers auto-reset for leaf binds).
local function register_entries(entries, parent_slug, in_submap)
  for key_spec, value in pairs(entries) do
    local chord = resolve_key(key_spec)

    if value.group then
      -- === Submap container ===
      local slug = make_slug(value.group, parent_slug)

      -- Collect children (everything except "group" key)
      local children = {}
      for k, v in pairs(value) do
        if k ~= "group" then
          children[k] = v
        end
      end

      -- Entry chord → enter this submap
      hl.bind(chord, hl.dsp.submap(slug), { description = value.group })

      -- Define the submap
      hl.define_submap(slug, function()
        -- Auto: escape → reset, backspace → parent (or reset at root level)
        hl.bind("escape", hl.dsp.submap("reset"), { description = "Close" })
        hl.bind("backspace", hl.dsp.submap(parent_slug or "reset"), { description = parent_slug and "Back" or "Close" })

        -- Register all children in this submap context
        register_entries(children, slug, true)

        -- Catch-all: any undefined key press resets to global
        hl.bind("catchall", hl.dsp.submap("reset"))
      end)
    else
      -- === Leaf bind ===
      if in_submap then
        -- Auto-reset submap to global after dispatching the action
        local action = value[1]
        hl.bind(chord, function()
          hl.dispatch(action)
          hl.dispatch(hl.dsp.submap("reset"))
        end, build_opts(value))
      else
        hl.bind(chord, value[1], build_opts(value))
      end
    end
  end
end

-- Main entry point
function M.bind_keys(entries)
  register_entries(entries, nil, false)
end

return M
