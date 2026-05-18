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
-- XWAYLAND
-- ====================================================================

hl.config({
  xwayland = {
    enabled = settings.xwayland.enabled,
    use_nearest_neighbor = settings.xwayland.use_nearest_neighbor,
    force_zero_scaling = settings.xwayland.force_zero_scaling,
    create_abstract_socket = settings.xwayland.create_abstract_socket,
  },
})

-- ====================================================================
-- OPENGL
-- ====================================================================

hl.config({
  opengl = {
    nvidia_anti_flicker = settings.opengl.nvidia_anti_flicker,
  },
})

-- ====================================================================
-- RENDER
-- ====================================================================

hl.config({
  render = {
    cm_auto_hdr = settings.render.cm_auto_hdr,
    cm_enabled = settings.render.cm_enabled,
    cm_sdr_eotf = settings.render.cm_sdr_eotf,
    commit_timing_enabled = settings.render.commit_timing_enabled,
    ctm_animation = settings.render.ctm_animation,
    direct_scanout = settings.render.direct_scanout,
    expand_undersized_textures = settings.render.expand_undersized_textures,
    fp16_sdr_tf = settings.render.fp16_sdr_tf,
    icc_vcgt_enabled = settings.render.icc_vcgt_enabled,
    keep_unmodified_copy = settings.render.keep_unmodified_copy,
    new_render_scheduling = settings.render.new_render_scheduling,
    non_shader_cm = settings.render.non_shader_cm,
    non_shader_cm_interop = settings.render.non_shader_cm_interop,
    send_content_type = settings.render.send_content_type,
    use_fp16 = settings.render.use_fp16,
    use_shader_blur_blend = settings.render.use_shader_blur_blend,
    xp_mode = settings.render.xp_mode,
  },
})

-- ====================================================================
-- GROUP / TABBING
-- ====================================================================

hl.config({
  group = {
    auto_group = settings.group.auto_group,
    drag_into_group = settings.group.drag_into_group,
    focus_removed_window = settings.group.focus_removed_window,
    group_on_movetoworkspace = settings.group.group_on_movetoworkspace,
    insert_after_current = settings.group.insert_after_current,
    merge_floated_into_tiled_on_groupbar = settings.group.merge_floated_into_tiled_on_groupbar,
    merge_groups_on_drag = settings.group.merge_groups_on_drag,
    merge_groups_on_groupbar = settings.group.merge_groups_on_groupbar,

    col = {
      border_active = colors.c4,
      border_inactive = colors.base,
      border_locked_active = colors.c4,
      border_locked_inactive = colors.base,
    },

    groupbar = {
      blur = settings.group.groupbar.blur,
      enabled = settings.group.groupbar.enabled,
      font_family = settings.group.groupbar.font_family,
      font_size = settings.group.groupbar.font_size,
      font_weight_active = settings.group.groupbar.font_weight_active,
      font_weight_inactive = settings.group.groupbar.font_weight_inactive,
      gaps_in = settings.group.groupbar.gaps_in,
      gaps_out = settings.group.groupbar.gaps_out,
      gradient_round_only_edges = settings.group.groupbar.gradient_round_only_edges,
      gradient_rounding = settings.group.groupbar.gradient_rounding,
      gradient_rounding_power = settings.group.groupbar.gradient_rounding_power,
      gradients = settings.group.groupbar.gradients,
      height = settings.group.groupbar.height,
      indicator_gap = settings.group.groupbar.indicator_gap,
      indicator_height = settings.group.groupbar.indicator_height,
      keep_upper_gap = settings.group.groupbar.keep_upper_gap,
      middle_click_close = settings.group.groupbar.middle_click_close,
      priority = settings.group.groupbar.priority,
      render_titles = settings.group.groupbar.render_titles,
      round_only_edges = settings.group.groupbar.round_only_edges,
      rounding = settings.group.groupbar.rounding,
      rounding_power = settings.group.groupbar.rounding_power,
      scrolling = settings.group.groupbar.scrolling,
      stacked = settings.group.groupbar.stacked,
      text_color = colors.standard,
      text_color_inactive = colors.muted,
      text_color_locked_active = colors.standard,
      text_color_locked_inactive = colors.muted,
      text_offset = settings.group.groupbar.text_offset,
      text_padding = settings.group.groupbar.text_padding,

      col = {
        active = colors.c4,
        inactive = colors.base,
        locked_active = colors.c4,
        locked_inactive = colors.base,
      },
    },
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

  master = {
    mfact = settings.master.mfact,
    orientation = settings.master.orientation,
    new_status = settings.master.new_status,
    new_on_active = settings.master.new_on_active,
    new_on_top = settings.master.new_on_top,
    drop_at_cursor = settings.master.drop_at_cursor,
    smart_resizing = settings.master.smart_resizing,
    allow_small_split = settings.master.allow_small_split,
    always_keep_position = settings.master.always_keep_position,
    center_ignores_reserved = settings.master.center_ignores_reserved,
    center_master_fallback = settings.master.center_master_fallback,
    slave_count_for_center_master = settings.master.slave_count_for_center_master,
    special_scale_factor = settings.master.special_scale_factor,
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

  binds = {
    allow_workspace_cycles = settings.binds.allow_workspace_cycles,
    workspace_back_and_forth = settings.binds.workspace_back_and_forth,
    focus_preferred_method = settings.binds.focus_preferred_method,
    scroll_event_delay = settings.binds.scroll_event_delay,
    allow_pin_fullscreen = settings.binds.allow_pin_fullscreen,
    disable_keybind_grabbing = settings.binds.disable_keybind_grabbing,
    drag_threshold = settings.binds.drag_threshold,
    hide_special_on_workspace_change = settings.binds.hide_special_on_workspace_change,
    ignore_group_lock = settings.binds.ignore_group_lock,
    movefocus_cycles_fullscreen = settings.binds.movefocus_cycles_fullscreen,
    movefocus_cycles_groupfirst = settings.binds.movefocus_cycles_groupfirst,
    pass_mouse_when_bound = settings.binds.pass_mouse_when_bound,
    window_direction_monitor_fallback = settings.binds.window_direction_monitor_fallback,
    workspace_center_on = settings.binds.workspace_center_on,
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

-- ====================================================================
-- DEVICES  (per-device input overrides, from settings)
-- ====================================================================

for _, dev in ipairs(settings.devices) do
  hl.device(dev)
end
