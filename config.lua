-- config.lua — Hyprland configuration blocks, curves, animations, gestures
-- Values come from settings.lua (preferences.json + machine.json)

local settings = require("settings")
local colors = require("colors")
local utils = require("utils")

-- ====================================================================
-- CURSOR
-- ====================================================================

hl.config({
  cursor = {
    no_hardware_cursors = settings.cursor.no_hardware_cursors,
    zoom_factor = settings.cursor.zoom_factor,
    zoom_rigid = settings.cursor.zoom_rigid,
    enable_hyprcursor = settings.cursor.enable_hyprcursor,
  },
})

-- ====================================================================
-- MAIN LOOK AND FEEL
-- ====================================================================

hl.config({
  general = {
    border_size = settings.general.border_size,
    gaps_in = settings.general.gaps_in,
    gaps_out = settings.general.gaps_out,
    gaps_workspaces = settings.general.gaps_workspaces,

    col = {
      active_border = colors.c4,
      inactive_border = colors.base,
    },

    layout = settings.general.layout,
    no_focus_fallback = settings.general.no_focus_fallback,
    resize_on_border = settings.general.resize_on_border,
    extend_border_grab_area = settings.general.extend_border_grab_area,
    allow_tearing = settings.general.allow_tearing,
    resize_corner = settings.general.resize_corner,
  },

  decoration = {
    rounding = settings.decoration.rounding,
    active_opacity = settings.decoration.active_opacity,
    inactive_opacity = settings.decoration.inactive_opacity,
    fullscreen_opacity = settings.decoration.fullscreen_opacity,

    shadow = {
      enabled = settings.decoration.shadow.enabled,
      range = settings.decoration.shadow.range,
      render_power = settings.decoration.shadow.render_power,
      sharp = settings.decoration.shadow.sharp,
      color = settings.decoration.shadow.color,
      offset = { settings.decoration.shadow.offset.x, settings.decoration.shadow.offset.y },
      scale = settings.decoration.shadow.scale,
    },

    dim_inactive = settings.decoration.dim.inactive,
    dim_strength = settings.decoration.dim.strength,
    dim_special = settings.decoration.dim.special,
    dim_around = settings.decoration.dim.around,

    blur = {
      enabled = settings.decoration.blur.enabled,
      size = settings.decoration.blur.size,
      passes = settings.decoration.blur.passes,
      ignore_opacity = settings.decoration.blur.ignore_opacity,
      new_optimizations = settings.decoration.blur.new_optimizations,
      xray = settings.decoration.blur.xray,
      noise = settings.decoration.blur.noise,
      contrast = settings.decoration.blur.contrast,
      brightness = settings.decoration.blur.brightness,
      vibrancy = settings.decoration.blur.vibrancy,
      vibrancy_darkness = settings.decoration.blur.vibrancy_darkness,
      special = settings.decoration.blur.special,
      popups = settings.decoration.blur.popups,
      popups_ignorealpha = settings.decoration.blur.popups_ignorealpha,
    },
  },

  animations = {
    enabled = settings.animations.enabled,
  },

  misc = {
    force_default_wallpaper = settings.misc.force_default_wallpaper,
    disable_hyprland_logo = settings.misc.disable_hyprland_logo,
    disable_splash_rendering = settings.misc.disable_splash_rendering,
    initial_workspace_tracking = settings.misc.initial_workspace_tracking,
    enable_anr_dialog = settings.misc.enable_anr_dialog,
  },

  dwindle = {
    preserve_split = settings.dwindle.preserve_split,
    force_split = settings.dwindle.force_split,
    precise_mouse_move = settings.dwindle.precise_mouse_move,
  },

  input = {
    kb_layout = settings.input.kb_layout,
    numlock_by_default = settings.input.numlock_by_default,
    accel_profile = settings.input.accel_profile,
    scroll_method = settings.input.scroll_method,
    follow_mouse = settings.input.follow_mouse,
    special_fallthrough = settings.input.special_fallthrough,
    sensitivity = settings.input.sensitivity,

    touchpad = {
      disable_while_typing = settings.input.touchpad.disable_while_typing,
      natural_scroll = settings.input.touchpad.natural_scroll,
      scroll_factor = settings.input.touchpad.scroll_factor,
    },

    tablet = {
      output = settings.input.tablet.output,
    },
  },

  gestures = {
    workspace_swipe_distance = settings.gestures.workspace_swipe_distance,
    workspace_swipe_touch = settings.gestures.workspace_swipe_touch,
    workspace_swipe_invert = settings.gestures.workspace_swipe_invert,
    workspace_swipe_min_speed_to_force = settings.gestures.workspace_swipe_min_speed_to_force,
    workspace_swipe_cancel_ratio = settings.gestures.workspace_swipe_cancel_ratio,
    workspace_swipe_direction_lock = settings.gestures.workspace_swipe_direction_lock,
    workspace_swipe_forever = settings.gestures.workspace_swipe_forever,
  },
})

-- ====================================================================
-- BEZIER CURVES  (from settings)
-- ====================================================================

for name, curve in pairs(settings.bezier_curves) do
  hl.curve(name, curve)
end

-- ====================================================================
-- ANIMATIONS  (from settings)
-- ====================================================================

for leaf, opts in pairs(settings.animation_entries) do
  hl.animation({
    leaf = leaf,
    enabled = opts.enabled,
    speed = opts.speed,
    bezier = opts.bezier,
    style = opts.style,
  })
end

-- ====================================================================
-- GESTURE SPECS  (from settings)
-- ====================================================================

for _, spec in ipairs(settings.gesture_specs) do
  if spec.action == "workspace" then
    hl.gesture({ fingers = spec.fingers, direction = spec.direction, action = "workspace" })
  elseif spec.action == "tctl" then
    hl.gesture({
      fingers = spec.fingers,
      direction = spec.direction,
      action = function() hl.exec_cmd(utils.tctl_bin() .. " " .. spec.command) end,
    })
  else
    hl.gesture({ fingers = spec.fingers, direction = spec.direction, action = spec.action })
  end
end
