# Settings Schema Plan — `settings-schema.json`

## Overview

Replace the hardcoded `DEFAULTS = { ... }` table in `settings.lua` with a single declarative JSON file (`settings-schema.json`) that serves two purposes:

1. **Source of defaults** — strip metadata keys → clean config table → merge with user files
2. **GUI metadata** — the QML settings frontend reads it to auto-generate UI (tabs, sections, controls, help text)

The schema defines every possible Hyprland setting, even ones not yet consumed by Lua modules. Unconsumed settings are ignored at runtime but visible in the GUI (with a "not yet applied" indicator).

---

## Architecture

### Data Flow

```
settings-schema.json (at /usr/share/terra/hyprland/settings-schema.json)
         │
         ▼
   strip_meta()   ──  removes all $ keys, resolves $default/$defaults
         │
         ▼
   flatten_categories()  ──  lifts category wrappers up one level
         │
         ▼
   DEFAULTS table  (same shape as current Lua DEFAULTS)
         │
         ├── deep_merge(preferences.json stripped)
         │
         └── deep_merge(machine.json stripped)
                    │
                    ▼
              settings table
              (consumed by all Lua modules)
```

### File Locations

| File | Path | Purpose |
|------|------|---------|
| `settings-schema.json` | `/usr/share/terra/hyprland/settings-schema.json` | Schema + defaults (single source of truth) |
| `preferences.json` | `~/.config/terra/hyprland/preferences.json` | User's personal preferences (shared across machines) |
| `machine.json` | `~/.config/terra/hyprland/machine.json` | Machine-specific overrides (not shared) |

### Merge Rules (unchanged)

```
DEFAULTS < preferences.json < machine.json
```

- Scalars: machine overrides preferences overrides defaults
- Tables (objects): recursively deep-merged
- Arrays: concatenated (machine appended to preferences)

---

## Schema Metadata Keys

All keys starting with `$` are metadata — stripped by `strip_meta()` on load.

### Section/Field-Level Keys

| Key | Scope | Purpose | Example |
|-----|-------|---------|---------|
| `$ui_label` | category wrapper | Human-readable name for GUI tab | `"Display"`, `"Window Management"` |
| `$icon` | any | Material icon name for GUI | `"dashboard"`, `"monitor"`, `"keyboard"` |
| `$help` | any | Tooltip/description text | `"Gap between windows in pixels"` |
| `$type` | field | Accepted value type(s) | `"int"`, `"float \| 'auto'"` |
| `$default` | field | Default scalar value | `6`, `true`, `"us"` |
| `$defaults` | field | Default content for array or dynamic-key sections | `["cmd1"]`, `{ ... }` |
| `$min` | field (numeric) | Minimum value | `0` |
| `$max` | field (numeric) | Maximum value | `50` |
| `$values` | field (enum) | List of allowed string values | `["dwindle", "master"]` |
| `$examples` | field (string) | GUI suggestion values | `["auto", "0x0"]` |
| `$items` | array/dynamic field | Template describing each item's fields | `{ "$type": "str" }` |
| `$is_machine_local` | section | Default save destination in GUI | `true` or absent (means preference) |

### `$type` Syntax

A single string describing accepted values. Parsed by the GUI to render the correct control.

| Syntax | Meaning | Example Field |
|--------|---------|---------------|
| `"int"` | Integer | `general.gaps_in` |
| `"float"` | Floating-point number | `decoration.rounding` |
| `"str"` | Any string | `general.layout` |
| `"bool"` | `true` or `false` | `decoration.shadow.enabled` |
| `"enum"` | One of a set of strings (listed in `$values`) | `general.layout` |
| `"int \| str"` | Integer OR any string | `misc.initial_workspace_tracking` |
| `"int \| 'auto'"` | Integer OR literal `"auto"` | — |
| `"float \| 'auto'"` | Float OR literal `"auto"` | `monitors[].position`, `monitors[].scale` |
| `"str \| 'preferred'"` | Any string OR literal `"preferred"` | `monitors[].mode` |

The GUI parser splits on `|`:
- Unquoted tokens → type constraints (`float`, `int`, `str`, `bool`)
- Single-quoted tokens (`'auto'`) → literal string values allowed in place of the numeric type

---

## Category Wrapper Pattern

The schema uses parent objects purely for GUI organization (tabs and subtabs). They have no effect on the final config shape.

### Detection Heuristic

An object is a **category wrapper** if **every non-`$` child is itself a table** (has no direct scalar values):

```json
"window": {
  "$ui_label": "Window Management",
  "$icon": "dashboard",
  "general": {        ← table child → category child
    "gaps_in": { "$type": "int", "$default": 6 }
  },
  "decoration": {     ← table child → category child
    "rounding": { "$type": "int", "$default": 16 }
  }
}
```

An object is a **regular section** if it has direct scalar or leaf settings:

```json
"general": {
  "gaps_in": 6,         ← scalar → NOT a category
  "border_size": 0
}
```

### Flattening

`flatten_categories()` lifts all children of category wrappers up one level:

```
Input:  { window = { general = { gaps_in = 6 }, decoration = { rounding = 16 } } }
Output: { general = { gaps_in = 6 }, decoration = { rounding = 16 } }
```

This preserves `settings.general.gaps_in` for all consuming Lua modules.

### Nesting

Categories can nest to any depth for GUI subtabs:

```
environment  (tab)
  └── cursor     (subsection)
  └── env        (subsection)
  └── programs   (subsection)
```

The flattening is recursive — non-category children are lifted all the way to the top level.

---

## Schema Structure (All Categories and Sections)

### Category: `window` — Window Management

```json
"window": {
  "$ui_label": "Window Management",
  "$icon": "dashboard",
```

#### `general`

| $type | Key | Default | Min | Max | $help |
|-------|-----|---------|-----|-----|-------|
| int | `border_size` | 0 | 0 | 20 | Border thickness in pixels |
| int | `gaps_in` | 6 | 0 | 50 | Gap between windows in a layout |
| int | `gaps_out` | 12 | 0 | 50 | Gap between windows and screen edges |
| int | `gaps_workspaces` | 6 | 0 | 50 | Gap between workspace monitors |
| enum | `layout` | `"dwindle"` | — | — | Layout plugin (`$values`: `["dwindle", "master"]`) |
| bool | `no_focus_fallback` | false | — | — | Don't auto-focus when focused window closes |
| bool | `resize_on_border` | true | — | — | Resize by dragging window border |
| int | `extend_border_grab_area` | 15 | 0 | 50 | Extended border grab area in pixels |
| bool | `allow_tearing` | false | — | — | Allow window tearing |
| int \| str | `resize_corner` | 0 | 0 | — | Resize corner (int, or `"auto"` etc.) |

Note: `col.active_border` and `col.inactive_border` are driven by the palette system (colors.lua), not JSON.

#### `decoration`

```
shadow { ... }
dim { ... }
blur { ... }
```

#### `animations`

```
enabled: bool = true
```

#### `dwindle`

```
preserve_split: bool = true
force_split: int = 2
precise_mouse_move: bool = true
```

#### `master` — NOT YET CONSUMED

```
mfact: float = 0.5, $min: 0, $max: 1
smart_count: int = 0
orientation: enum = "center", $values: ["left", "center", "right"]
new_status: enum = "slave", $values: ["slave", "master"]
always_center_master: bool = false
smart_resizing: bool = true
drop_at_cursor: bool = true
new_on_active: bool = false
new_on_top: bool = false
```

---

### Category: `display` — Display

```json
"display": {
  "$ui_label": "Display",
  "$icon": "monitor",
```

#### `monitors`

`$is_machine_local: true`

Array of objects. Each item:

| $type | Key | Default | Min | Max | $help |
|-------|-----|---------|-----|-----|-------|
| str | `output` | `""` | — | — | Monitor name. `""` = catch-all for unspecified outputs |
| str \| 'preferred' | `mode` | `"preferred"` | — | — | Display mode string |
| str | `position` | `"auto"` | — | — | Position (`$examples`: `["auto", "auto-left", "0x0", "1920x0"]`) |
| float \| 'auto' | `scale` | 1.0 | 0.5 | 5.0 | Display scale factor |
| str | `mirror` | `""` | — | — | Mirror another output |
| bool | `disabled` | false | — | — | Disable this output |
| int | `vrr` | 0 | 0 | 2 | VRR mode (0=off, 1=on, 2=always) |

`$defaults`: one catch-all entry — `[{ "output": "", "mode": "preferred", "position": "auto", "scale": 1.0 }]`

#### `misc`

```
force_default_wallpaper: int = 0, $min: 0, $max: 2
disable_hyprland_logo: bool = false
disable_splash_rendering: bool = true
initial_workspace_tracking: int = 0
enable_anr_dialog: bool = false
```

#### `render` — NOT YET CONSUMED

```
direct_scanout: bool = false
explicit_sync: int = 0, $min: 0, $max: 2
explicit_sync_khz: int = 0
explicit_sync_use_begin: bool = true
explicit_sync_use_end: bool = true
explicit_sync_use_finish: bool = true
```

#### `xwayland` — NOT YET CONSUMED

```
use_nearest_neighbor: bool = true
force_zero_scaling: bool = false
```

#### `opengl` — NOT YET CONSUMED

```
nvidia_anti_flicker: bool = false
force_hyprland_glx: bool = false
glx_context_type: enum = "attrib", $values: ["attrib", "class"]
```

---

### Category: `input` — Input

```json
"input": {
  "$ui_label": "Input",
  "$icon": "keyboard",
```

#### `input`

```
kb_layout: str = "us"
numlock_by_default: bool = true
accel_profile: str = "flat"    ($examples: ["flat", "adaptive"])
scroll_method: str = "2fg"     ($examples: ["2fg", "button", "edge"])
follow_mouse: int = 1, $min: 0, $max: 3
special_fallthrough: bool = false
sensitivity: float = 0, $min: -1, $max: 1

touchpad {
  disable_while_typing: bool = true
  natural_scroll: bool = true
  scroll_factor: float = 0.7, $min: 0.1, $max: 5.0
}

tablet {
  output: str = "current"
}
```

#### `gestures`

```
workspace_swipe_distance: int = 300, $min: 0
workspace_swipe_touch: bool = true
workspace_swipe_invert: bool = true
workspace_swipe_min_speed_to_force: int = 5, $min: 1
workspace_swipe_cancel_ratio: float = 0.5, $min: 0, $max: 1
workspace_swipe_direction_lock: bool = false
workspace_swipe_forever: bool = true
```

#### `gesture_specs`

Array of objects. Each item:

| $type | Key | Default | $help |
|-------|-----|---------|-------|
| int | `fingers` | 3 | Number of fingers |
| str | `direction` | — | Gesture direction (`$values`: `["left", "right", "up", "down", "horizontal"]`) |
| str | `action` | — | Action type (`$values`: `["workspace", "tctl"]`) |
| str | `command` | `""` | tctl subcommand (only when `action` is `"tctl"`) |

`$defaults`: 5 entries matching the current hardcoded gestures.

#### `devices` — NOT YET CONSUMED

`$is_machine_local: true`

Array of per-device input overrides. Each item:

| $type | Key | Default | $help |
|-------|-----|---------|-------|
| str | `name` | — | Device name from `hyprctl devices` |
| str | `accel_profile` | `"flat"` | Acceleration profile |
| float | `sensitivity` | 0 | Sensitivity (-1 to 1) |
| bool | `natural_scroll` | — | Enable natural scrolling |
| bool | `disable_while_typing` | — | Disable while typing |
| bool | `tap_to_click` | — | Enable tap-to-click |
| int | `scroll_factor` | — | Scroll speed factor |
| int | `repeat_rate` | — | Key repeat rate |
| int | `repeat_delay` | — | Key repeat delay |

`$defaults`: `[]` (empty — user adds entries for specific devices).

#### `group` — NOT YET CONSUMED (Window Grouping/Tabbing)

```
insert_after_current: bool = true
auto_group: bool = false
merge_group: bool = false
open_new_window: bool = true
group_on_movetoworkspace: bool = false
focus_removed_window: bool = true
dragging_toggles: bool = false
col.border_active_group: str = "rgb(...)"    ← falls back to palette
col.border_inactive_group: str = "rgb(...)"
groupbar {
  enabled: bool = true
  font_size: int = 8
  gradients: bool = true
  height: int = 14
  priority: str = "none"  ($values: ["none", "title", "order"])
  render_titles: bool = true
  scrolling: bool = true
  text_color: str = "rgb(...)"
}
```

---

### Category: `environment` — Environment

```json
"environment": {
  "$ui_label": "Environment",
  "$icon": "settings",
```

#### `cursor`

```
theme: str = "Bibata-Modern-Classic"
size: int = 24, $min: 16, $max: 96
no_hardware_cursors: bool = true
zoom_factor: float = 1.0, $min: 1.0, $max: 5.0    ← NOT YET CONSUMED
zoom_rigid: bool = false                            ← NOT YET CONSUMED
enable_hyprcursor: bool = true                      ← NOT YET CONSUMED
```

#### `env`

Dynamic object — keys are env var names, values are strings.

```
$defaults: all current env vars (XCURSOR_THEME, XCURSOR_SIZE, XDG_CURRENT_DESKTOP, etc.)
```

#### `autostart`

Array of strings.

```
$items: { "$type": "str" }
$defaults: all current autostart commands (systemctl, awww, kdeconnectd, cliphist, hyprsunset, matugen)
```

Note: terrashell launcher and `hyprctl setcursor` are handled in `hyprland.lua` directly, not in this array.

#### `programs`

```
terminal: str = "foot zellij-session-picker"
quickterm: str = "foot zellij attach -c quickterm"
file_manager: str = "dolphin"
browser: str = "firefox"
```

#### `keys`

```
modifiers {
  main: str = "SUPER"
  mut: str = "SHIFT"
  scope: str = "CTRL"
  sys: str = "ALT"
}
leader: str = "SUPER + SPACE"
```

---

### Category: `rules` — Rules

```json
"rules": {
  "$ui_label": "Rules",
  "$icon": "rule",
```

#### `window_rules`

```
suppress_maximize: bool = true
fullscreen_classes: array of str = ["steam_app*", "factorio*", "Terraria*"]
additional: array of rule objects = []
```

Array items in `additional` are free-form rule objects (passed directly to `hl.window_rule()`).

#### `layer_rules`

```
no_anim_namespaces: array of str = ["^quickshell(.*)?$", "selection"]
animation_overrides: array of { namespace: str, animation: str } = [
  { "namespace": "wvkbd", "animation": "slide bottom" }
]
```

#### `workspace_rules`

Array of objects. Each item:

| $type | Key | Required | $help |
|-------|-----|----------|-------|
| str | `workspace` | yes | Workspace identifier (e.g. `"special:quickterm"`, `"1"`, `"name:dev"`) |
| obj | `gaps_out` | no | Per-workspace outer gaps `{ top: int, left: int, bottom: int, right: int }` |
| str | `on_created_empty` | no | Command to run when workspace is created empty |

`$defaults`: one entry for the quickterm scratchpad.

---

### Category: `advanced` — Advanced

```json
"advanced": {
  "$ui_label": "Advanced",
  "$icon": "tune",
```

#### `bezier_curves`

Dynamic-key object. Each key is a curve name, value has:

| $type | Key | Default | $help |
|-------|-----|---------|-------|
| str | `type` | `"bezier"` | Curve type |
| array | `points` | — | 2 control points: `[[x1, y1], [x2, y2]]` |

`$defaults`: `bounce` and `smooth-in` curves.

#### `animation_entries`

Dynamic-key object. Each key is a Hyprland animation leaf name, value has:

| $type | Key | Default | $help |
|-------|-----|---------|-------|
| bool | `enabled` | true | Enable this animation |
| float | `speed` | 3 | Animation speed (higher = faster) |
| str | `bezier` | `"bounce"` | Bezier curve name from `bezier_curves` |
| str | `style` | `"slide"` | Animation style |

`$defaults`: all 7 current leaves (windows, windowsOut, layers, layersOut, workspaces, specialWorkspace, specialWorkspaceOut).

#### `binds` — NOT YET CONSUMED (config-level, NOT keybindings)

```
allow_workspace_cycles: bool = true
workspace_back_and_forth: bool = false
focus_preferred_method: int = 0, $min: 0, $max: 1
ignore_auto_repeat: bool = false
scroll_event_delay: int = 300
mouse_move_uses_keyboard_focus: bool = false
```

---

## `strip_meta()` Function Specification

Recursively strips metadata keys from the schema to produce a clean config table.

### Behavior

```lua
function strip_meta(v)
  -- Scalars pass through unchanged (handles user config leaf values)
  if type(v) ~= "table" then return v end

  -- If object has $default, it's a typed leaf → extract the default value
  if v["$default"] ~= nil then return v["$default"] end

  -- If object has $defaults, it's an array/dynamic default → strip and replace
  if v["$defaults"] ~= nil then return strip_meta(v["$defaults"]) end

  -- Otherwise, recurse into all non-$ keys (strip metadata, keep structure)
  local result = {}
  for k, val in pairs(v) do
    if type(k) ~= "string" or k:sub(1,1) ~= "$" then
      result[k] = strip_meta(val)
    end
  end
  return result
end
```

### Examples

```lua
-- Typed leaf
strip_meta({ "$type": "int", "$default": 6, "$min": 0, "$max": 50 })
  → 6

-- Typed array section
strip_meta({
  "$is_machine_local": true,
  "$items": { ... },
  "$defaults": [{ "output": "", "mode": "preferred" }]
})
  → [{ "output": "", "mode": "preferred" }]

-- Plain nested object (no $default)
strip_meta({
  "gaps_in": { "$type": "int", "$default": 6 },
  "border_size": { "$type": "int", "$default": 0 }
})
  → { gaps_in = 6, border_size = 0 }

-- Category wrapper
strip_meta({
  "$ui_label": "Display",
  "monitors": { ... },
  "misc": { ... }
})
  → { monitors = { ... }, misc = { ... } }
  -- (Category detection is separate; strip_meta just removes $ keys)
```

## `flatten_categories()` Function Specification

Applied AFTER `strip_meta()`. Detects category wrappers and lifts their children to the top level.

### Behavior

```lua
function flatten_categories(t)
  local result = {}
  for k, v in pairs(t) do
    if type(v) == "table" and type(k) == "string" and k:sub(1,1) ~= "$" then
      local is_category = true
      for ck, cv in pairs(v) do
        if type(ck) ~= "string" or ck:sub(1,1) == "$" then
          -- skip meta keys
        elseif type(cv) ~= "table" then
          is_category = false  -- has a direct scalar value = regular section
          break
        end
      end
      if is_category then
        -- Lift all non-$ children up one level
        for ck, cv in pairs(v) do
          if type(ck) ~= "string" or ck:sub(1,1) ~= "$" then
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
```

### Examples

```lua
-- Category wrapper
flatten_categories({
  window = {
    general = { gaps_in = 6, border_size = 0 },
    decoration = { rounding = 16 },
  },
  display = {
    monitors = {},
    misc = { force_default_wallpaper = 0 },
  },
})
  → {
    general = { gaps_in = 6, border_size = 0 },
    decoration = { rounding = 16 },
    monitors = {},
    misc = { force_default_wallpaper = 0 },
  }

-- Regular section (passes through)
flatten_categories({
  general = { gaps_in = 6 },
})
  → { general = { gaps_in = 6 } }

-- Mixed (category + regular at same level)
flatten_categories({
  window = {             ← category (children are all tables)
    general = { ... },
    decoration = { ... },
  },
  version = 1,           ← scalar, not a category
})
  → {
    general = { ... },   ← lifted from window
    decoration = { ... }, ← lifted from window
    version = 1,         ← passed through
  }
```

---

## Changes to `settings.lua`

### What to remove

- The entire `DEFAULTS = { ... }` table (~215 lines of hardcoded values)

### What to add

1. **`strip_meta()` function** — as specified above
2. **`flatten_categories()` function** — as specified above
3. **Schema loading** — replace DEFAULTS with loading from file:

```lua
-- Determine schema path (system install, with local-dev fallback)
local home = os.getenv("HOME")
local schema_paths = {
  home .. "/dev/terra-de/terra-hyprland/settings-schema.json",  -- dev
  "/usr/share/terra/hyprland/settings-schema.json",             -- system
}

local schema_file
for _, p in ipairs(schema_paths) do
  local f = io.open(p, "r")
  if f then
    schema_file = p
    f:close()
    break
  end
end

if not schema_file then
  error("settings-schema.json not found")
end

local raw_schema = read_json_file(schema_file)
if not raw_schema then
  error("Failed to parse settings-schema.json")
end

-- Strip metadata then flatten categories to get clean defaults
local DEFAULTS = flatten_categories(strip_meta(raw_schema))
```

4. **Merge pipeline** — unchanged (already merges DEFAULTS < preferences.json < machine.json)

### What stays the same

- `parse_json()` / `to_lua()` — the JSON → Lua converter
- `read_json_file()` — file reader
- `deep_merge()` — merge logic
- `log` module integration
- The return value: `return settings`

---

## What Stays Completely Unchanged

- `hyprland.lua` — still calls `settings.env`, `settings.autostart`, `settings.cursor`, `settings.monitors`
- `config.lua` — still reads `settings.general.*`, `settings.decoration.*`, etc.
- `rules.lua` — still reads `settings.window_rules.*`, `settings.layer_rules.*`
- `workspaces.lua` — still reads `settings.workspace_rules`
- `mods.lua` — still reads `settings.keys.modifiers.*`
- `programs.lua` — still reads `settings.programs.*`
- `binds.lua` — no change (keybindings stay in Lua)
- `colors.lua` — no change (reads palette.json independently)
- `log.lua` — no change
- `preferences.json` / `machine.json` — no format change. Users still write the same flat config files.

---

## Schema File Installation

`settings-schema.json` ships with the `terra-hyprland` package:

In `PKGBUILD`:
```bash
install -Dm644 settings-schema.json "$pkgdir/usr/share/terra/hyprland/settings-schema.json"
```

The schema is NOT user-editable. If users want different defaults, they put overrides in `preferences.json` or `machine.json`.

---

## Implementation Order

1. Write `settings-schema.json` with all sections (consumed + unconsumed)
2. Add `strip_meta()` and `flatten_categories()` to `settings.lua`
3. Replace `DEFAULTS` table with schema loading + stripping + flattening
4. Test that all settings resolve to the same values as the hardcoded DEFAULTS
5. Update `PKGBUILD` to install the schema file
6. Verify the live session works with the new loading path
7. (Future) Build the QML settings app on top of the schema metadata

---

## Edge Cases and Considerations

### Arrays are concatenated, not overridden

The `deep_merge` concatenates arrays from machine.json onto preferences.json. The schema's `$defaults` arrays become the initial DEFAULTS. If the user has an array in preferences.json, it's concatenated onto the defaults. If machine.json also has entries, they're appended to preferences.

This means monitors don't replace each other — they accumulate. For most users this is fine (they only define monitors in machine.json). If someone puts monitors in both files, they'd get duplicates. Document this behavior.

### Fields with no `$default`

Some fields might have no `$default` (e.g. optional fields). `strip_meta` returns `nil` for these. `deep_merge` handles nil values correctly — the key simply doesn't exist in the result, and consuming Lua code gets `nil` (or uses its own default).

### `$is_machine_local` is advisory

This key tells the GUI where to save by default. It does NOT enforce which file the setting goes in. A user can put any setting in either file. The merge rules handle it regardless.

### Backward compatibility

The output of `strip_meta(flatten_categories(schema))` must produce the exact same table shape as the current hardcoded `DEFAULTS`. This can be verified by loading the schema and comparing key-by-key in a test script.

### Error handling

If `settings-schema.json` can't be parsed (corrupt file, I/O error), `settings.lua` should error at require time. This is a hard failure — the schema is the source of truth, and without it the config system can't work. Unlike `preferences.json` / `machine.json` (which silently fall back to defaults when missing), the schema must be present.
