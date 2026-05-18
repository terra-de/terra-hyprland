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
    inactive_timeout = settings.cursor.inactive_timeout,
    hide_on_key_press = settings.cursor.hide_on_key_press,
    hide_on_touch = settings.cursor.hide_on_touch,
    hide_on_tablet = settings.cursor.hide_on_tablet,
    no_warps = settings.cursor.no_warps,
    persistent_warps = settings.cursor.persistent_warps,
    warp_on_change_workspace = settings.cursor.warp_on_change_workspace,
    warp_on_toggle_special = settings.cursor.warp_on_toggle_special,
    warp_back_after_non_mouse_input = settings.cursor.warp_back_after_non_mouse_input,
    default_monitor = settings.cursor.default_monitor,
    min_refresh_rate = settings.cursor.min_refresh_rate,
    hotspot_padding = settings.cursor.hotspot_padding,
    invisible = settings.cursor.invisible,
    no_break_fs_vrr = settings.cursor.no_break_fs_vrr,
    use_cpu_buffer = settings.cursor.use_cpu_buffer,
    sync_gsettings_theme = settings.cursor.sync_gsettings_theme,
    zoom_detached_camera = settings.cursor.zoom_detached_camera,
    zoom_disable_aa = settings.cursor.zoom_disable_aa,
  },
})

-- ====================================================================
-- SCROLLING LAYOUT
-- ====================================================================

hl.config({
  scrolling = {
    direction = settings.scrolling.direction,
    follow_focus = settings.scrolling.follow_focus,
    follow_min_visible = settings.scrolling.follow_min_visible,
    fullscreen_on_one_column = settings.scrolling.fullscreen_on_one_column,
    column_width = settings.scrolling.column_width,
    explicit_column_widths = settings.scrolling.explicit_column_widths,
    focus_fit_method = settings.scrolling.focus_fit_method,
    wrap_focus = settings.scrolling.wrap_focus,
    wrap_swapcol = settings.scrolling.wrap_swapcol,
  },
})

-- ====================================================================
-- LAYOUT
-- ====================================================================

hl.config({
  layout = {
    single_window_aspect_ratio = settings.layout.single_window_aspect_ratio,
    single_window_aspect_ratio_tolerance = settings.layout.single_window_aspect_ratio_tolerance,
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

    layout = settings.general.layout,
    no_focus_fallback = settings.general.no_focus_fallback,
    resize_on_border = settings.general.resize_on_border,
    extend_border_grab_area = settings.general.extend_border_grab_area,
    allow_tearing = settings.general.allow_tearing,
    resize_corner = settings.general.resize_corner,
    float_gaps = settings.general.float_gaps,
    hover_icon_on_border = settings.general.hover_icon_on_border,
    locale = settings.general.locale,
    modal_parent_blocking = settings.general.modal_parent_blocking,

    col = {
      active_border = colors.c4,
      inactive_border = colors.base,
      nogroup_border = colors.base,
      nogroup_border_active = colors.c4,
    },

    snap = {
      enabled = settings.general.snap.enabled,
      border_overlap = settings.general.snap.border_overlap,
      monitor_gap = settings.general.snap.monitor_gap,
      respect_gaps = settings.general.snap.respect_gaps,
      window_gap = settings.general.snap.window_gap,
    },
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
      color_inactive = settings.decoration.shadow.color_inactive,
      offset = { settings.decoration.shadow.offset.x, settings.decoration.shadow.offset.y },
      scale = settings.decoration.shadow.scale,
    },

    dim_inactive = settings.decoration.dim.inactive,
    dim_strength = settings.decoration.dim.strength,
    dim_special = settings.decoration.dim.special,
    dim_around = settings.decoration.dim.around,
    dim_modal = settings.decoration.dim.modal,

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
      input_methods = settings.decoration.blur.input_methods,
      input_methods_ignorealpha = settings.decoration.blur.input_methods_ignorealpha,
    },

    border_part_of_window = settings.decoration.border_part_of_window,
    rounding_power = settings.decoration.rounding_power,
    screen_shader = settings.decoration.screen_shader,

    glow = {
      enabled = settings.decoration.glow.enabled,
      range = settings.decoration.glow.range,
      color = settings.decoration.glow.color,
      color_inactive = settings.decoration.glow.color_inactive,
      render_power = settings.decoration.glow.render_power,
    },
  },

  animations = {
    enabled = settings.animations.enabled,
    workspace_wraparound = settings.animations.workspace_wraparound,
  },

  misc = {
    force_default_wallpaper = settings.misc.force_default_wallpaper,
    disable_hyprland_logo = settings.misc.disable_hyprland_logo,
    disable_splash_rendering = settings.misc.disable_splash_rendering,
    initial_workspace_tracking = settings.misc.initial_workspace_tracking,
    enable_anr_dialog = settings.misc.enable_anr_dialog,
    disable_autoreload = settings.misc.disable_autoreload,
    background_color = settings.misc.background_color,
    font_family = settings.misc.font_family,
    splash_font_family = settings.misc.splash_font_family,
    vrr = settings.misc.vrr,
    mouse_move_enables_dpms = settings.misc.mouse_move_enables_dpms,
    key_press_enables_dpms = settings.misc.key_press_enables_dpms,
    mouse_move_focuses_monitor = settings.misc.mouse_move_focuses_monitor,
    always_follow_on_dnd = settings.misc.always_follow_on_dnd,
    layers_hog_keyboard_focus = settings.misc.layers_hog_keyboard_focus,
    animate_manual_resizes = settings.misc.animate_manual_resizes,
    animate_mouse_windowdragging = settings.misc.animate_mouse_windowdragging,
    enable_swallow = settings.misc.enable_swallow,
    swallow_regex = settings.misc.swallow_regex,
    swallow_exception_regex = settings.misc.swallow_exception_regex,
    focus_on_activate = settings.misc.focus_on_activate,
    render_unfocused_fps = settings.misc.render_unfocused_fps,
    lockdead_screen_delay = settings.misc.lockdead_screen_delay,
    anr_missed_pings = settings.misc.anr_missed_pings,
    allow_session_lock_restore = settings.misc.allow_session_lock_restore,
    close_special_on_empty = settings.misc.close_special_on_empty,
    exit_window_retains_fullscreen = settings.misc.exit_window_retains_fullscreen,
    middle_click_paste = settings.misc.middle_click_paste,
    disable_scale_notification = settings.misc.disable_scale_notification,
    disable_xdg_env_checks = settings.misc.disable_xdg_env_checks,
    disable_hyprland_guiutils_check = settings.misc.disable_hyprland_guiutils_check,
    disable_watchdog_warning = settings.misc.disable_watchdog_warning,
    screencopy_force_8b = settings.misc.screencopy_force_8b,
    session_lock_xray = settings.misc.session_lock_xray,
    size_limits_tiled = settings.misc.size_limits_tiled,
    name_vk_after_proc = settings.misc.name_vk_after_proc,
    on_focus_under_fullscreen = settings.misc.on_focus_under_fullscreen,

    col = {
      splash = colors.standard,
    },
  },

  dwindle = {
    preserve_split = settings.dwindle.preserve_split,
    force_split = settings.dwindle.force_split,
    precise_mouse_move = settings.dwindle.precise_mouse_move,
    smart_split = settings.dwindle.smart_split,
    smart_resizing = settings.dwindle.smart_resizing,
    default_split_ratio = settings.dwindle.default_split_ratio,
    split_bias = settings.dwindle.split_bias,
    split_width_multiplier = settings.dwindle.split_width_multiplier,
    permanent_direction_override = settings.dwindle.permanent_direction_override,
    use_active_for_splits = settings.dwindle.use_active_for_splits,
    special_scale_factor = settings.dwindle.special_scale_factor,
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
    kb_variant = settings.input.kb_variant,
    kb_options = settings.input.kb_options,
    kb_rules = settings.input.kb_rules,
    kb_model = settings.input.kb_model,
    kb_file = settings.input.kb_file,
    numlock_by_default = settings.input.numlock_by_default,
    accel_profile = settings.input.accel_profile,
    scroll_method = settings.input.scroll_method,
    follow_mouse = settings.input.follow_mouse,
    follow_mouse_threshold = settings.input.follow_mouse_threshold,
    follow_mouse_shrink = settings.input.follow_mouse_shrink,
    special_fallthrough = settings.input.special_fallthrough,
    sensitivity = settings.input.sensitivity,
    natural_scroll = settings.input.natural_scroll,
    left_handed = settings.input.left_handed,
    focus_on_close = settings.input.focus_on_close,
    mouse_refocus = settings.input.mouse_refocus,
    float_switch_override_focus = settings.input.float_switch_override_focus,
    repeat_rate = settings.input.repeat_rate,
    repeat_delay = settings.input.repeat_delay,
    scroll_factor = settings.input.scroll_factor,
    scroll_button = settings.input.scroll_button,
    scroll_button_lock = settings.input.scroll_button_lock,
    scroll_points = settings.input.scroll_points,
    emulate_discrete_scroll = settings.input.emulate_discrete_scroll,
    off_window_axis_events = settings.input.off_window_axis_events,
    rotation = settings.input.rotation,
    force_no_accel = settings.input.force_no_accel,
    resolve_binds_by_sym = settings.input.resolve_binds_by_sym,

    touchpad = {
      disable_while_typing = settings.input.touchpad.disable_while_typing,
      natural_scroll = settings.input.touchpad.natural_scroll,
      scroll_factor = settings.input.touchpad.scroll_factor,
      tap_to_click = settings.input.touchpad.tap_to_click,
      clickfinger_behavior = settings.input.touchpad.clickfinger_behavior,
      tap_button_map = settings.input.touchpad.tap_button_map,
      drag_lock = settings.input.touchpad.drag_lock,
      tap_and_drag = settings.input.touchpad.tap_and_drag,
      middle_button_emulation = settings.input.touchpad.middle_button_emulation,
      flip_x = settings.input.touchpad.flip_x,
      flip_y = settings.input.touchpad.flip_y,
      drag_3fg = settings.input.touchpad.drag_3fg,
    },

    tablet = {
      output = settings.input.tablet.output,
      relative_input = settings.input.tablet.relative_input,
      left_handed = settings.input.tablet.left_handed,
      transform = settings.input.tablet.transform,
      region_position = settings.input.tablet.region_position ~= "" and settings.input.tablet.region_position or nil,
      region_size = settings.input.tablet.region_size ~= "" and settings.input.tablet.region_size or nil,
      active_area_position = settings.input.tablet.active_area_position ~= "" and settings.input.tablet.active_area_position or nil,
      active_area_size = settings.input.tablet.active_area_size ~= "" and settings.input.tablet.active_area_size or nil,
      absolute_region_position = settings.input.tablet.absolute_region_position,
    },

    touchdevice = {
      enabled = settings.input.touchdevice.enabled,
      output = settings.input.touchdevice.output,
      transform = settings.input.touchdevice.transform,
    },

    virtualkeyboard = {
      release_pressed_on_close = settings.input.virtualkeyboard.release_pressed_on_close,
      share_states = settings.input.virtualkeyboard.share_states,
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
    workspace_swipe_create_new = settings.gestures.workspace_swipe_create_new,
    workspace_swipe_direction_lock_threshold = settings.gestures.workspace_swipe_direction_lock_threshold,
    workspace_swipe_touch_invert = settings.gestures.workspace_swipe_touch_invert,
    workspace_swipe_use_r = settings.gestures.workspace_swipe_use_r,
    close_max_timeout = settings.gestures.close_max_timeout,

    scrolling = {
      move_snap_cursor = settings.gestures.scrolling.move_snap_cursor,
      move_snap_to_grid = settings.gestures.scrolling.move_snap_to_grid,
    },
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
