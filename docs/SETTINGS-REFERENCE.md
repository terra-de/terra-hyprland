# terra-hyprland Settings Reference

Two JSON files control Hyprland configuration under `~/.config/terra/hyprland/`:

| File | Purpose | Example Content | Version-Controlled? |
|------|---------|-----------------|---------------------|
| `preferences.json` | Personal preferences shared across machines | gaps, animations, programs, env vars, window rules | Yes (dotfiles) |
| `machine.json` | Machine-specific overrides | monitors, per-device input, machine env vars | No |

## Merge Rules (last wins)

```
Built-in DEFAULTS < preferences.json < machine.json
```

1. **Scalars** — `machine.json` overrides `preferences.json` overrides built-in defaults.
2. **Tables (objects)** — recursively deep-merged. `machine.json` keys overlay `preferences.json` keys.
3. **Arrays** — concatenated. `machine.json` items are appended after `preferences.json` items.

If either file is missing or has a parse error, it is silently skipped and defaults are used.

---

## Section Reference

> **Conventions:**
> - `⇦ pref` — key belongs in `preferences.json`
> - `⇦ mach` — key belongs in `machine.json`
> - `⇦ both` — key can appear in both; machine overrides/deep-merges
> - Types: `str` = string, `num` = number, `bool` = boolean, `arr` = array, `obj` = object

---

### `cursor`

Controls the Hyprland cursor.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `theme` | `str` | `"Bibata-Modern-Classic"` | Cursor theme name |
| `size` | `num` | `24` | Cursor size in pixels |
| `no_hardware_cursors` | `bool` | `true` | Disable hardware cursors |

**⇦ pref** — Example:
```json
"cursor": {
  "theme": "Bibata-Modern-Classic",
  "size": 24,
  "no_hardware_cursors": true
}
```

Hyprland equivalent: `hl.config({ cursor = { no_hardware_cursors = true } })`  
Also sets `XCURSOR_THEME` / `XCURSOR_SIZE` env vars and `hyprctl setcursor` on autostart.

---

### `general`

Core window management settings.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `border_size` | `num` | `0` | Border thickness in pixels |
| `gaps_in` | `num` | `6` | Gap between windows in a layout |
| `gaps_out` | `num` | `12` | Gap between windows and screen edges |
| `gaps_workspaces` | `num` | `6` | Gap between workspace monitors |
| `layout` | `str` | `"dwindle"` | Layout plugin (`"dwindle"` or `"master"`) |
| `no_focus_fallback` | `bool` | `false` | Don't focus a window when the focused one closes |
| `resize_on_border` | `bool` | `true` | Resize windows by dragging on border |
| `extend_border_grab_area` | `num` | `15` | Extended border grab area in pixels |
| `allow_tearing` | `bool` | `false` | Allow window tearing |
| `resize_corner` | `num` | `0` | Resize corner |

Border colors (`col.active_border`, `col.inactive_border`) are driven by the active palette, not JSON. To override them, use `window_rules.additional` with `bordercolor` rules.

**⇦ pref** — Example:
```json
"general": {
  "gaps_in": 6,
  "gaps_out": 12,
  "border_size": 0,
  "layout": "dwindle",
  "resize_on_border": true
}
```

Hyprland equivalent: `hl.config({ general = { ... } })`

---

### `decoration`

Window decoration: rounding, opacity, shadows, dimming, blur.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `rounding` | `num` | `16` | Corner rounding in pixels |
| `active_opacity` | `num` | `1.0` | Opacity of focused windows (`0.0`–`1.0`) |
| `inactive_opacity` | `num` | `1.0` | Opacity of unfocused windows |
| `fullscreen_opacity` | `num` | `1.0` | Opacity of fullscreen windows |

#### `decoration.shadow`

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `enabled` | `bool` | `true` | Enable drop shadows |
| `range` | `num` | `30` | Shadow blur range in pixels |
| `render_power` | `num` | `3` | Shadow render quality (higher = sharper) |
| `sharp` | `bool` | `false` | Sharp shadow edges |
| `color` | `str` | `"rgba(00000050)"` | Shadow color in Hyprland format |
| `offset` | `obj` | `{"x": 1, "y": 1}` | Shadow offset in pixels |
| `scale` | `num` | `1.0` | Shadow scale |

#### `decoration.dim`

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `inactive` | `bool` | `true` | Dim unfocused windows |
| `strength` | `num` | `0.1` | Dim strength (`0.0`–`1.0`) |
| `special` | `num` | `0.1` | Dim strength for special workspaces |
| `around` | `num` | `0.4` | Dim area around popups/menus |

#### `decoration.blur`

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `enabled` | `bool` | `false` | Enable blur behind windows |
| `size` | `num` | `8` | Blur kernel size |
| `passes` | `num` | `3` | Number of blur passes |
| `ignore_opacity` | `bool` | `true` | Ignore window opacity when blurring |
| `new_optimizations` | `bool` | `true` | Use optimized blur path |
| `xray` | `bool` | `false` | Xray mode (blurs only behind text) |
| `noise` | `num` | `0.07` | Noise amount |
| `contrast` | `num` | `1.2` | Contrast adjustment |
| `brightness` | `num` | `1.7` | Brightness adjustment |
| `vibrancy` | `num` | `0.8` | Vibrancy |
| `vibrancy_darkness` | `num` | `0.4` | Vibrancy darkness |
| `special` | `bool` | `false` | Enable blur for special workspaces |
| `popups` | `bool` | `true` | Blur behind popups |
| `popups_ignorealpha` | `num` | `0.2` | Ignore popups below this alpha |

**⇦ pref** — Example:
```json
"decoration": {
  "rounding": 16,
  "shadow": {
    "enabled": true,
    "range": 30,
    "color": "rgba(00000050)"
  },
  "blur": {
    "enabled": false,
    "size": 8,
    "passes": 3
  }
}
```

Hyprland equivalent: `hl.config({ decoration = { ... } })`

---

### `animations`

Simple toggle for the `animations` config block.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `enabled` | `bool` | `true` | Enable animations globally |

Note: Individual animation entries are configured in `animation_entries`. Bezier curves are configured in `bezier_curves`.

**⇦ pref** — Example:
```json
"animations": {
  "enabled": true
}
```

Hyprland equivalent: `hl.config({ animations = { enabled = true } })`

---

### `misc`

Miscellaneous Hyprland settings.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `force_default_wallpaper` | `num` | `0` | Force default wallpaper (0–2, 0 = disabled) |
| `disable_hyprland_logo` | `bool` | `false` | Hide Hyprland logo on launch |
| `disable_splash_rendering` | `bool` | `true` | Disable splash text |
| `initial_workspace_tracking` | `num` | `0` | Track initial workspace per monitor |
| `enable_anr_dialog` | `bool` | `false` | Show ANR (app not responding) dialog |

**⇦ pref** — Example:
```json
"misc": {
  "force_default_wallpaper": 0,
  "disable_splash_rendering": true,
  "enable_anr_dialog": false
}
```

Hyprland equivalent: `hl.config({ misc = { ... } })`

---

### `dwindle`

Dwindle layout-specific settings.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `preserve_split` | `bool` | `true` | Preserve split direction when opening new windows |
| `force_split` | `num` | `2` | Split direction override (0 = no, 1 = horizontal, 2 = vertical) |
| `precise_mouse_move` | `bool` | `true` | Accurate mouse positioning for resize/focus |

**⇦ pref** — Example:
```json
"dwindle": {
  "preserve_split": true,
  "force_split": 2,
  "precise_mouse_move": true
}
```

Hyprland equivalent: `hl.config({ dwindle = { ... } })`

---

### `input`

Keyboard, touchpad, and tablet input settings.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `kb_layout` | `str` | `"us"` | Keyboard layout |
| `numlock_by_default` | `bool` | `true` | Enable numlock on startup |
| `accel_profile` | `str` | `"flat"` | Pointer acceleration profile |
| `scroll_method` | `str` | `"2fg"` | Scroll method (`"2fg"`, `"button"`, `"on_button_down"`, `"edge"`) |
| `follow_mouse` | `num` | `1` | Follow mouse focus mode (0–3) |
| `special_fallthrough` | `bool` | `false` | Key presses fall through special workspace |
| `sensitivity` | `num` | `0` | Pointer sensitivity (`-1.0`–`1.0`) |

#### `input.touchpad`

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `disable_while_typing` | `bool` | `true` | Disable touchpad while typing |
| `natural_scroll` | `bool` | `true` | Natural (reverse) scrolling |
| `scroll_factor` | `num` | `0.7` | Touchpad scroll speed factor |

#### `input.tablet`

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `output` | `str` | `"current"` | Tablet output mapping |

**⇦ both** — Base settings in `preferences.json`, overrides in `machine.json`:
```json
"input": {
  "kb_layout": "us",
  "numlock_by_default": true,
  "touchpad": {
    "natural_scroll": true,
    "scroll_factor": 0.7
  }
}
```

Hyprland equivalent: `hl.config({ input = { ... } })`

---

### `gestures`

Workspace swipe gesture configuration.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `workspace_swipe_distance` | `num` | `300` | Swipe distance to trigger workspace change |
| `workspace_swipe_touch` | `bool` | `true` | Enable touch swipe |
| `workspace_swipe_invert` | `bool` | `true` | Invert swipe direction |
| `workspace_swipe_min_speed_to_force` | `num` | `5` | Minimum swipe speed |
| `workspace_swipe_cancel_ratio` | `num` | `0.5` | Cancel ratio threshold |
| `workspace_swipe_direction_lock` | `bool` | `false` | Lock swipe direction |
| `workspace_swipe_forever` | `bool` | `true` | Allow infinite swipe without wrapping |

**⇦ pref** — Example:
```json
"gestures": {
  "workspace_swipe_distance": 300,
  "workspace_swipe_touch": true,
  "workspace_swipe_forever": true
}
```

Hyprland equivalent: `hl.config({ gestures = { ... } })`

---

### `bezier_curves`

Named bezier curves used by animation entries. Each key is the curve name, value is an object with `type` and `points`.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `<name>.type` | `str` | `"bezier"` | Curve type (only `"bezier"` supported) |
| `<name>.points` | `arr` | — | Array of 2 control point arrays: `[[x1,y1], [x2,y2]]` |

**⇦ pref** — Example:
```json
"bezier_curves": {
  "bounce": {
    "type": "bezier",
    "points": [[0.38, 1.21], [0.22, 1.0]]
  },
  "smooth-in": {
    "type": "bezier",
    "points": [[0.3, 0.0], [0.8, 0.15]]
  }
}
```

Hyprland equivalent: `hl.curve("bounce", { type = "bezier", points = { { 0.38, 1.21 }, { 0.22, 1.0 } } })`

---

### `animation_entries`

Per-leaf animation overrides. Keys are Hyprland animation leaf names.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `<leaf>.enabled` | `bool` | varies | Enable this animation |
| `<leaf>.speed` | `num` | varies | Animation speed (higher = faster) |
| `<leaf>.bezier` | `str` | varies | Name of bezier curve from `bezier_curves` |
| `<leaf>.style` | `str` | varies | Animation style (e.g. `"slide"`, `"slide top"`, `"slidevert"`) |

Default leaves:

| Leaf | Default speed | Default bezier | Default style |
|------|--------------|----------------|---------------|
| `windows` | `3` | `bounce` | `slide` |
| `windowsOut` | `3` | `bounce` | `slide` |
| `layers` | `2` | `bounce` | `slide top` |
| `layersOut` | `2` | `smooth-in` | `slide top` |
| `workspaces` | `3.5` | `bounce` | `slide` |
| `specialWorkspace` | `3` | `bounce` | `slidevert` |
| `specialWorkspaceOut` | `2` | `smooth-in` | `slidevert` |

**⇦ pref** — Example:
```json
"animation_entries": {
  "windows": { "enabled": true, "speed": 3, "bezier": "bounce", "style": "slide" },
  "workspaces": { "enabled": true, "speed": 3.5, "bezier": "bounce", "style": "slide" }
}
```

Hyprland equivalent: `hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "bounce", style = "slide" })`

---

### `gesture_specs`

Three-finger and four-finger touchpad gesture bindings.

| Key | Type | Description |
|-----|------|-------------|
| `fingers` | `num` | Number of fingers (3 or 4) |
| `direction` | `str` | Gesture direction: `"left"`, `"right"`, `"up"`, `"down"`, `"horizontal"` |
| `action` | `str` | Action type: `"workspace"` (built-in swipe), `"tctl"` (tctl command), or any Hyprland gesture action |
| `command` | `str` | Required when `action` is `"tctl"`. The tctl subcommand and args. |

**⇦ pref** — Example:
```json
"gesture_specs": [
  { "fingers": 4, "direction": "horizontal", "action": "workspace" },
  { "fingers": 3, "direction": "left", "action": "tctl", "command": "gesture left" },
  { "fingers": 3, "direction": "right", "action": "tctl", "command": "gesture right" }
]
```

Hyprland equivalent: `hl.gesture({ fingers = N, direction = "...", action = fn })`

---

### `env`

Environment variables set before the compositor starts.

Keys are variable names, values are the variable values (as strings).

**⇦ both** — Base vars in `preferences.json`, machine-specific overrides in `machine.json`:
```json
"env": {
  "XCURSOR_THEME": "Bibata-Modern-Classic",
  "XCURSOR_SIZE": "24",
  "XDG_CURRENT_DESKTOP": "Hyprland",
  "QT_QPA_PLATFORM": "wayland",
  "GTK_ICON_THEME": "material-actions"
}
```

Hyprland equivalent: `hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")`

---

### `autostart`

Array of shell commands to run on session start. Commands run in sequence on the `hyprland.start` event.

Terrashell launcher and cursor setter are handled automatically by `hyprland.lua` (not from this array).

**⇦ pref** — Example:
```json
"autostart": [
  "systemctl --user start hyprpolkitagent",
  "awww-daemon",
  "wl-paste --watch cliphist store"
]
```

Hyprland equivalent: `hl.on("hyprland.start", function() hl.exec_cmd("...") end)`

---

### `programs`

Application paths used by keybindings and workspace rules.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `terminal` | `str` | `"foot zellij-session-picker"` | Terminal emulator command |
| `quickterm` | `str` | `"foot zellij attach -c quickterm"` | Quick terminal (scratchpad) command |
| `file_manager` | `str` | `"dolphin"` | File manager command |
| `browser` | `str` | `"firefox"` | Web browser command |

**⇦ pref** — Example:
```json
"programs": {
  "terminal": "foot zellij-session-picker",
  "file_manager": "dolphin",
  "browser": "firefox"
}
```

Consumed in Lua via `local programs = require("programs")` then `programs.terminal`.

---

### `keys`

Modifier key aliases and leader key chord. Used by the keybinding system in `binds.lua`.

#### `keys.modifiers`

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `main` | `str` | `"SUPER"` | Primary modifier (Main key: `"SUPER"`, `"ALT"`, `"CTRL"`) |
| `mut` | `str` | `"SHIFT"` | Mutation modifier (Move/scale operations) |
| `scope` | `str` | `"CTRL"` | Scope modifier (Resize/layout operations) |
| `sys` | `str` | `"ALT"` | System modifier (Third-party operations) |

#### `keys.leader`

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `leader` | `str` | `"SUPER + SPACE"` | Leader key chord for submaps |

**⇦ pref** — Example:
```json
"keys": {
  "modifiers": {
    "main": "SUPER",
    "mut": "SHIFT",
    "scope": "CTRL",
    "sys": "ALT"
  },
  "leader": "SUPER + SPACE"
}
```

Consumed in Lua by `mods.lua` and used by `binds.lua` via `utils.bind_keys()`.

---

### `window_rules`

Window matching rules for effects like fullscreen, nofocus, opacity, and more.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `suppress_maximize` | `bool` | `true` | Add a suppress_maximize rule for all windows |
| `fullscreen_classes` | `arr[str]` | `["steam_app*", "factorio*", "Terraria*"]` | Window classes that auto-fullscreen |
| `additional` | `arr[obj]` | `[]` | Array of additional window rule objects |

Each entry in `additional` is passed directly to `hl.window_rule()`:
```json
{ "match": { "class": "someapp" }, "float": true, "no_focus": true }
```

**⇦ both** — Base rules in `preferences.json`, extra rules in `machine.json` (appended):

```json
"window_rules": {
  "suppress_maximize": true,
  "fullscreen_classes": ["steam_app*", "factorio*"],
  "additional": [
    { "match": { "title": "Calculator" }, "float": true, "size": { "w": 400, "h": 500 } }
  ]
}
```

Hyprland equivalent: `hl.window_rule({ match = { class = "..." }, ... })`

---

### `layer_rules`

Rules for layer surfaces (shell panels, overlays, keyboards).

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `no_anim_namespaces` | `arr[str]` | `["^quickshell(.*)?$", "selection"]` | Layer namespace patterns to disable animations on |
| `animation_overrides` | `arr[obj]` | `[{namespace: "wvkbd", animation: "slide bottom"}]` | Layer rules with animation overrides |

Each entry in `animation_overrides`:
```json
{ "namespace": "wvkbd", "animation": "slide bottom" }
```

**⇦ pref** — Example:
```json
"layer_rules": {
  "no_anim_namespaces": ["^quickshell(.*)?$", "selection"],
  "animation_overrides": [
    { "namespace": "wvkbd", "animation": "slide bottom" }
  ]
}
```

Hyprland equivalent:
```lua
hl.layer_rule({ match = { namespace = "^quickshell" }, no_anim = true })
hl.layer_rule({ match = { namespace = "wvkbd" }, animation = "slide bottom" })
```

---

### `workspace_rules`

Per-workspace configuration: gaps, on-created programs, and other workspace properties.

Array of objects with these fields:

| Key | Type | Required | Description |
|-----|------|----------|-------------|
| `workspace` | `str` | yes | Workspace identifier (e.g. `"special:quickterm"`, `"1"`, `"name:dev"`) |
| `gaps_out` | `obj` | no | Per-workspace outer gaps: `{ top, left, bottom, right }` (all `num`) |
| `on_created_empty` | `str` | no | Command to run when the workspace is created empty |

**⇦ both** — Base in `preferences.json`, additional in `machine.json` (appended):

```json
"workspace_rules": [
  {
    "workspace": "special:quickterm",
    "gaps_out": { "top": 150, "left": 30, "bottom": 0, "right": 30 },
    "on_created_empty": "foot zellij attach -c quickterm"
  }
]
```

Hyprland equivalent: `hl.workspace_rule({ workspace = "special:quickterm", gaps_out = { top = 150, ... } })`

---

### `monitors`

Monitor output configuration. **Only meaningful in `machine.json`** (or the DEFAULTS empty array is used).

Array of objects with these fields:

| Key | Type | Required | Description |
|-----|------|----------|-------------|
| `output` | `str` | yes | Monitor name (e.g. `"eDP-1"`, `"HDMI-A-1"`) |
| `mode` | `str` | yes | Mode string: `"preferred"`, `"1920x1080"`, `"1920x1080@144"` |
| `position` | `str` | yes | Position: `"auto"`, `"auto-left"`, `"0x0"`, `"1920x0"` |
| `scale` | `num` | yes | Display scale factor (e.g. `1.5`, `2.0`) |
| `mirror` | `str` | no | Mirror another output |
| `disabled` | `bool` | no | Disable this output |
| `vrr` | `num` | no | VRR mode (0 = off, 1 = on, 2 = always) |

**⇦ mach** — Example:
```json
"monitors": [
  { "output": "eDP-1", "mode": "preferred", "position": "auto", "scale": 1.5 },
  { "output": "HDMI-A-1", "mode": "1920x1080@144", "position": "auto-right", "scale": 1.0 }
]
```

Hyprland equivalent: `hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1.5 })`

---

## File Structure Summary

### `preferences.json` — Portable personal settings

```
cursor              → hl.config({ cursor })
general             → hl.config({ general })
decoration          → hl.config({ decoration })
animations.enabled  → hl.config({ animations })
misc                → hl.config({ misc })
dwindle             → hl.config({ dwindle })
input               → hl.config({ input })         (base, machine can override)
gestures            → hl.config({ gestures })
bezier_curves       → hl.curve(name, {...})
animation_entries   → hl.animation({ leaf, ... })
gesture_specs       → hl.gesture({ fingers, ... })
env                 → hl.env(key, value)           (base, machine can override)
autostart           → hl.exec_cmd(cmd)
programs            → Lua programs.* constants
keys.modifiers      → Lua mods.aliases
keys.leader         → Lua mods.leader
window_rules        → hl.window_rule({...})        (base, machine can append)
layer_rules         → hl.layer_rule({...})
workspace_rules     → hl.workspace_rule({...})     (base, machine can append)
```

### `machine.json` — Machine-specific overrides

```
monitors            → hl.monitor({...})
input               → hl.config({ input })         (overrides preferences)
env                 → hl.env(key, value)           (overrides preferences)
window_rules        → hl.window_rule({...})        (appended to preferences)
workspace_rules     → hl.workspace_rule({...})     (appended to preferences)
```

---

## Compatibility

- **Breaking change**: Schema version field (`"version": 1`) is reserved for future validation. Currently unused.
- **Defaults**: Every key has a built-in default matching terra-hyprland's original hardcoded values. Files can be minimal (only override what you want to change).
- **Omission**: If a file or key is missing, the built-in default is used silently.
