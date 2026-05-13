-- Hyprland configuration blocks, curves, animations, gestures

local colors = require("colors")

-- Cursor
hl.config({
    cursor = {
        no_hardware_cursors = true,
    },
})

-- Main look and feel
hl.config({
    general = {
        border_size = 0,
        gaps_in = 6,
        gaps_out = 12,
        gaps_workspaces = 6,

        col = {
            active_border = colors.c4 or "rgb(69374f)",
            inactive_border = colors.base or "rgb(39232d)",
        },

        layout = "dwindle",
        no_focus_fallback = false,
        resize_on_border = true,
        extend_border_grab_area = 15,
        allow_tearing = false,
        resize_corner = 0,
    },

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
            ignore_window = true,
            color = "rgba(00000050)",
            offset = { 1, 1 },
            scale = 1.0,
        },

        dim_inactive = true,
        dim_strength = 0.1,
        dim_special = 0.1,
        dim_around = 0.4,

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

    animations = {
        enabled = true,
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = false,
        disable_splash_rendering = true,
        initial_workspace_tracking = 0,
        enable_anr_dialog = false,
    },

    dwindle = {
        preserve_split = true,
        force_split = 2,
        precise_mouse_move = true,
    },

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

    gestures = {
        workspace_swipe_distance = 300,
        workspace_swipe_touch = true,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 5,
        workspace_swipe_cancel_ratio = 0.5,
        workspace_swipe_direction_lock = false,
        workspace_swipe_forever = true,
    },
})

-- Animation curves (bezier)
hl.curve("shellSweet", { type = "bezier", points = { { 0.38, 1.21 }, { 0.22, 1.0 } } })
hl.curve("snappyAccel", { type = "bezier", points = { { 0.3, 0.0 }, { 0.8, 0.15 } } })

-- Animations
hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "shellSweet", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "shellSweet", style = "slide" })
hl.animation({ leaf = "layers", enabled = true, speed = 1, bezier = "shellSweet", style = "slide top" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1, bezier = "snappyAccel", style = "slide top" })
hl.animation({ leaf = "fade", enabled = true, speed = 0, bezier = "shellSweet" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "shellSweet", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 1, bezier = "shellSweet", style = "slidevert" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 1, bezier = "snappyAccel", style = "slidevert" })

-- Gesture specs
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "left", action = "dispatcher", dispatcher = hl.dsp.exec_cmd("tctl gesture left") })
hl.gesture({ fingers = 3, direction = "right", action = "dispatcher", dispatcher = hl.dsp.exec_cmd("tctl gesture right") })
hl.gesture({ fingers = 3, direction = "up", action = "dispatcher", dispatcher = hl.dsp.exec_cmd("tctl gesture up") })
hl.gesture({ fingers = 3, direction = "down", action = "dispatcher", dispatcher = hl.dsp.exec_cmd("tctl gesture down") })
