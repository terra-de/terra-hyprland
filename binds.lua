-- binds.lua — All Hyprland keybindings for Terra DE
--
-- Uses the bind_keys() declarative table format from utils.lua.
-- Key specs use modifier aliases: "main" → "SUPER", "mut" → "SHIFT", etc.
-- (see mods.lua for full alias table)
--
-- Tables with a "group" key become submaps. Everything else is a direct bind.
-- Submaps get auto escape→reset and backspace→parent.
--
-- The description flag doubles as which-key display text.
-- Icon prefix <icon_name> is parsed by WhichKeyService for Material icon rendering.

local utils = require("utils")

utils.bind_keys({

  -- ====================================================================
  -- HARDWARE / MEDIA KEYS
  -- ====================================================================

  ["XF86MonBrightnessDown"] = { hl.dsp.exec_cmd("tctl brightness down 5"),          desc = "Brightness down", locked = true, repeating = true },
  ["XF86MonBrightnessUp"]   = { hl.dsp.exec_cmd("tctl brightness up 5"),            desc = "Brightness up",   locked = true, repeating = true },

  ["XF86AudioLowerVolume"]  = { hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      desc = "Volume down", locked = true, repeating = true },
  ["XF86AudioRaiseVolume"]  = { hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), desc = "Volume up",   locked = true, repeating = true },
  ["XF86AudioMute"]         = { hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),                                           desc = "Mute",         locked = true },
  ["XF86AudioMicMute"]      = { hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),                                         desc = "Mic mute",     locked = true },

  ["XF86AudioNext"]         = { hl.dsp.exec_cmd("playerctl next"),                                                                       desc = "Next track",    locked = true },
  ["XF86AudioPause"]        = { hl.dsp.exec_cmd("playerctl play-pause"),                                                                 desc = "Play/pause",    locked = true },
  ["XF86AudioPlay"]         = { hl.dsp.exec_cmd("playerctl play-pause"),                                                                 desc = "Play/pause",    locked = true },
  ["XF86AudioPrev"]         = { hl.dsp.exec_cmd("playerctl previous"),                                                                   desc = "Previous track", locked = true },

  ["main-V"]                = { hl.dsp.exec_cmd("terrashell ipc call keyboard toggle"),                                                  desc = "Toggle OSK",    icon = "keyboard" },

  -- ====================================================================
  -- CORE NAVIGATION  — focus windows
  -- ====================================================================

  ["main-h"]     = { hl.dsp.focus({ direction = "left" }) },
  ["main-j"]     = { hl.dsp.focus({ direction = "down" }) },
  ["main-k"]     = { hl.dsp.focus({ direction = "up" }) },
  ["main-l"]     = { hl.dsp.focus({ direction = "right" }) },

  ["main-left"]  = { hl.dsp.focus({ direction = "left" }) },
  ["main-down"]  = { hl.dsp.focus({ direction = "down" }) },
  ["main-up"]    = { hl.dsp.focus({ direction = "up" }) },
  ["main-right"] = { hl.dsp.focus({ direction = "right" }) },

  -- ====================================================================
  -- WINDOW MUTATION  — move windows
  -- ====================================================================

  ["main-mut-h"]     = { hl.dsp.window.move({ direction = "left" }) },
  ["main-mut-j"]     = { hl.dsp.window.move({ direction = "down" }) },
  ["main-mut-k"]     = { hl.dsp.window.move({ direction = "up" }) },
  ["main-mut-l"]     = { hl.dsp.window.move({ direction = "right" }) },

  ["main-mut-left"]  = { hl.dsp.window.move({ direction = "left" }) },
  ["main-mut-down"]  = { hl.dsp.window.move({ direction = "down" }) },
  ["main-mut-up"]    = { hl.dsp.window.move({ direction = "up" }) },
  ["main-mut-right"] = { hl.dsp.window.move({ direction = "right" }) },

  -- ====================================================================
  -- WORKSPACE NAVIGATION
  -- ====================================================================

  -- Number workspace focus (0 = workspace 10)
  ["main-1"]            = { hl.dsp.focus({ workspace = 1 }),                         desc = "Workspace 1",  icon = "looks_one" },
  ["main-2"]            = { hl.dsp.focus({ workspace = 2 }),                         desc = "Workspace 2",  icon = "looks_two" },
  ["main-3"]            = { hl.dsp.focus({ workspace = 3 }),                         desc = "Workspace 3",  icon = "looks_3" },
  ["main-4"]            = { hl.dsp.focus({ workspace = 4 }),                         desc = "Workspace 4",  icon = "looks_4" },
  ["main-5"]            = { hl.dsp.focus({ workspace = 5 }),                         desc = "Workspace 5",  icon = "looks_5" },
  ["main-6"]            = { hl.dsp.focus({ workspace = 6 }),                         desc = "Workspace 6",  icon = "looks_6" },
  ["main-7"]            = { hl.dsp.focus({ workspace = 7 }),                         desc = "Workspace 7",  icon = "looks_7" },
  ["main-8"]            = { hl.dsp.focus({ workspace = 8 }),                         desc = "Workspace 8",  icon = "looks_8" },
  ["main-9"]            = { hl.dsp.focus({ workspace = 9 }),                         desc = "Workspace 9",  icon = "looks_9" },
  ["main-0"]            = { hl.dsp.focus({ workspace = 10 }),                        desc = "Workspace 10", icon = "looks_10" },

  -- Move to workspace
  ["main-mut-1"]        = { hl.dsp.window.move({ workspace = 1 }),                   desc = "Move to 1",   icon = "looks_one" },
  ["main-mut-2"]        = { hl.dsp.window.move({ workspace = 2 }),                   desc = "Move to 2",   icon = "looks_two" },
  ["main-mut-3"]        = { hl.dsp.window.move({ workspace = 3 }),                   desc = "Move to 3",   icon = "looks_3" },
  ["main-mut-4"]        = { hl.dsp.window.move({ workspace = 4 }),                   desc = "Move to 4",   icon = "looks_4" },
  ["main-mut-5"]        = { hl.dsp.window.move({ workspace = 5 }),                   desc = "Move to 5",   icon = "looks_5" },
  ["main-mut-6"]        = { hl.dsp.window.move({ workspace = 6 }),                   desc = "Move to 6",   icon = "looks_6" },
  ["main-mut-7"]        = { hl.dsp.window.move({ workspace = 7 }),                   desc = "Move to 7",   icon = "looks_7" },
  ["main-mut-8"]        = { hl.dsp.window.move({ workspace = 8 }),                   desc = "Move to 8",   icon = "looks_8" },
  ["main-mut-9"]        = { hl.dsp.window.move({ workspace = 9 }),                   desc = "Move to 9",   icon = "looks_9" },
  ["main-mut-0"]        = { hl.dsp.window.move({ workspace = 10 }),                  desc = "Move to 10",  icon = "looks_10" },

  -- Scroll through existing workspaces
  ["main-mouse_down"]   = { hl.dsp.focus({ workspace = "e+1" }),                     desc = "Next workspace",     icon = "arrow_forward" },
  ["main-mouse_up"]     = { hl.dsp.focus({ workspace = "e-1" }),                     desc = "Previous workspace", icon = "arrow_back" },

  -- Mouse drag/resize
  ["main-mouse:272"]    = { hl.dsp.window.drag(),                                     desc = "Move window",  mouse = true },
  ["main-mouse:273"]    = { hl.dsp.window.resize(),                                   desc = "Resize window", mouse = true },

  -- Empty workspace
  ["main-W"]            = { hl.dsp.focus({ workspace = "empty" }),                    desc = "Empty workspace",         icon = "add_box" },
  ["main-mut-W"]        = { hl.dsp.window.move({ workspace = "empty" }),              desc = "Move to empty workspace", icon = "move_to_inbox" },

  -- Quickterm
  ["main-T"]            = { hl.dsp.workspace.toggle_special("quickterm"),             desc = "Toggle quickterm", icon = "terminal" },
  ["main-mut-T"]        = { hl.dsp.window.move({ workspace = "special:quickterm" }),  desc = "Move to quickterm" },

  -- Game workspace
  ["main-G"]            = { hl.dsp.focus({ workspace = "name:Game" }),                desc = "Game workspace",  icon = "sports_esports" },
  ["main-mut-G"]        = { hl.dsp.window.move({ workspace = "name:Game" }),          desc = "Move to game workspace" },

  -- ====================================================================
  -- APPLICATION LAUNCH
  -- ====================================================================

  ["main-R"] = { hl.dsp.exec_cmd("tlgui launch"),               desc = "Run launcher",       icon = "rocket_launch" },
  ["main-F"] = { hl.dsp.exec_cmd("dolphin"),                    desc = "File manager",        icon = "folder" },
  ["main-Q"] = { hl.dsp.exec_cmd("foot zellij-session-picker"), desc = "Terminal",            icon = "terminal" },
  ["main-B"] = { hl.dsp.exec_cmd("firefox"),                    desc = "Browser",             icon = "language" },
  ["main-C"] = { hl.dsp.window.close(),                         desc = "Close window",        icon = "close" },

  -- ====================================================================
  -- SCOPE NAVIGATION  — workspace ±1
  -- ====================================================================

  ["main-scope-h"]     = { hl.dsp.focus({ workspace = -1 }), desc = "Previous workspace" },
  ["main-scope-l"]     = { hl.dsp.focus({ workspace = 1 }),  desc = "Next workspace" },
  ["main-scope-left"]  = { hl.dsp.focus({ workspace = -1 }), desc = "Previous workspace" },
  ["main-scope-right"] = { hl.dsp.focus({ workspace = 1 }),  desc = "Next workspace" },

  -- ====================================================================
  -- SCOPE MUTATION  — move window workspace ±1
  -- ====================================================================

  ["main-scope-mut-h"]     = { hl.dsp.window.move({ workspace = -1 }), desc = "Move window back" },
  ["main-scope-mut-l"]     = { hl.dsp.window.move({ workspace = 1 }),  desc = "Move window forward" },
  ["main-scope-mut-left"]  = { hl.dsp.window.move({ workspace = -1 }), desc = "Move window back" },
  ["main-scope-mut-right"] = { hl.dsp.window.move({ workspace = 1 }),  desc = "Move window forward" },

  -- ====================================================================
  -- LAYOUT RESIZE  — resize active window
  -- ====================================================================

  ["main-sys-h"]     = { hl.dsp.window.resize({ x = -20, y = 0, relative = true }),  desc = "Resize left" },
  ["main-sys-l"]     = { hl.dsp.window.resize({ x = 20, y = 0, relative = true }),   desc = "Resize right" },
  ["main-sys-j"]     = { hl.dsp.window.resize({ x = 0, y = 20, relative = true }),   desc = "Resize down" },
  ["main-sys-k"]     = { hl.dsp.window.resize({ x = 0, y = -20, relative = true }),  desc = "Resize up" },

  ["main-sys-left"]  = { hl.dsp.window.resize({ x = -20, y = 0, relative = true }),  desc = "Resize left" },
  ["main-sys-right"] = { hl.dsp.window.resize({ x = 20, y = 0, relative = true }),   desc = "Resize right" },
  ["main-sys-down"]  = { hl.dsp.window.resize({ x = 0, y = 20, relative = true }),   desc = "Resize down" },
  ["main-sys-up"]    = { hl.dsp.window.resize({ x = 0, y = -20, relative = true }),  desc = "Resize up" },

  -- ====================================================================
  -- UTILITIES
  -- ====================================================================

  ["main-sys-S"] = { hl.dsp.exec_cmd("grim -g \"$(slurp)\""), desc = "Screenshot region", icon = "screenshot" },

  -- ====================================================================
  -- LEADER KEY SUBMAP  — SUPER + SPACE
  -- ====================================================================

  ["main-space"] = {
    group = "Leader",

    y = { hl.dsp.workspace.toggle_special("quickterm"), desc = "Toggle quickterm", icon = "terminal" },
    r = { hl.dsp.exec_cmd("terrashell ipc call config reload"), desc = "Reload config", icon = "refresh" },

    u = {
      group = "Utilities",
      p = { hl.dsp.exec_cmd("hyprpicker -a"),            desc = "Color pick",          icon = "colorize" },
      s = { hl.dsp.exec_cmd("grim -g \"$(slurp)\""),     desc = "Screenshot region",   icon = "screenshot" },
      S = { hl.dsp.exec_cmd("grimblast --notify copy area"), desc = "Screenshot copy", icon = "screenshot" },
    },
  },
})
