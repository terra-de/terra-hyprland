-- binds.lua — All Hyprland keybindings for Terra DE
--
-- Uses the set_binds() API from utils.lua with Neovim-style patterns.
-- Pattern syntax: <alias-key> for modifier combos, bare chars for sequences.
--   <main-h>       → "SUPER + h" (immediate)
--   <main-mut-h>   → "SUPER + SHIFT + h" (immediate)
--   <leader>y      → "SUPER + SPACE" then "y" (which-key sequence)
--   <XF86...>      → literal key name (no modifiers)

local utils = require("utils")
local dsp = utils.dsp

-- ====================================================================
-- HARDWARE / MEDIA KEYS
-- ====================================================================

utils.set_binds({
  -- Brightness
  { "<XF86MonBrightnessDown>", dsp.exec_cmd("tctl brightness down 5"),  { desc = "Brightness down", locked = true, repeating = true } },
  { "<XF86MonBrightnessUp>",   dsp.exec_cmd("tctl brightness up 5"),    { desc = "Brightness up",   locked = true, repeating = true } },

  -- Volume
  { "<XF86AudioLowerVolume>",  dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),   { desc = "Volume down", locked = true, repeating = true } },
  { "<XF86AudioRaiseVolume>",  dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { desc = "Volume up", locked = true, repeating = true } },
  { "<XF86AudioMute>",         dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { desc = "Mute", locked = true } },
  { "<XF86AudioMicMute>",      dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { desc = "Mic mute", locked = true } },

  -- Media keys
  { "<XF86AudioNext>",  dsp.exec_cmd("playerctl next"),       { desc = "Next track", locked = true } },
  { "<XF86AudioPause>", dsp.exec_cmd("playerctl play-pause"), { desc = "Play/pause",  locked = true } },
  { "<XF86AudioPlay>",  dsp.exec_cmd("playerctl play-pause"), { desc = "Play/pause",  locked = true } },
  { "<XF86AudioPrev>",  dsp.exec_cmd("playerctl previous"),   { desc = "Previous track", locked = true } },

  -- On-screen keyboard
  { "<main-V>", dsp.exec_cmd("terrashell ipc call keyboard toggle"), { desc = "Toggle OSK" } },
})

-- ====================================================================
-- CORE NAVIGATION  — focus windows
-- ====================================================================

utils.set_binds({
  -- hjkl
  { "<main-h>", dsp.focus({ direction = "left" }),  { desc = "Focus left" } },
  { "<main-j>", dsp.focus({ direction = "down" }),  { desc = "Focus down" } },
  { "<main-k>", dsp.focus({ direction = "up" }),    { desc = "Focus up" } },
  { "<main-l>", dsp.focus({ direction = "right" }), { desc = "Focus right" } },

  -- Arrow keys
  { "<main-left>",  dsp.focus({ direction = "left" }),  { desc = "Focus left" } },
  { "<main-down>",  dsp.focus({ direction = "down" }),  { desc = "Focus down" } },
  { "<main-up>",    dsp.focus({ direction = "up" }),    { desc = "Focus up" } },
  { "<main-right>", dsp.focus({ direction = "right" }), { desc = "Focus right" } },
})

-- ====================================================================
-- WINDOW MUTATION  — move windows
-- ====================================================================

utils.set_binds({
  -- hjkl
  { "<main-mut-h>", dsp.window.move({ direction = "left" }),  { desc = "Move window left" } },
  { "<main-mut-j>", dsp.window.move({ direction = "down" }),  { desc = "Move window down" } },
  { "<main-mut-k>", dsp.window.move({ direction = "up" }),    { desc = "Move window up" } },
  { "<main-mut-l>", dsp.window.move({ direction = "right" }), { desc = "Move window right" } },

  -- Arrow keys
  { "<main-mut-left>",  dsp.window.move({ direction = "left" }),  { desc = "Move window left" } },
  { "<main-mut-down>",  dsp.window.move({ direction = "down" }),  { desc = "Move window down" } },
  { "<main-mut-up>",    dsp.window.move({ direction = "up" }),    { desc = "Move window up" } },
  { "<main-mut-right>", dsp.window.move({ direction = "right" }), { desc = "Move window right" } },
})

-- ====================================================================
-- WORKSPACE NAVIGATION
-- ====================================================================

utils.set_binds({
  -- Number workspace focus + move (0 = workspace 10)
  { "<main-1>", dsp.focus({ workspace = 1 }),       { desc = "Workspace 1" } },
  { "<main-2>", dsp.focus({ workspace = 2 }),       { desc = "Workspace 2" } },
  { "<main-3>", dsp.focus({ workspace = 3 }),       { desc = "Workspace 3" } },
  { "<main-4>", dsp.focus({ workspace = 4 }),       { desc = "Workspace 4" } },
  { "<main-5>", dsp.focus({ workspace = 5 }),       { desc = "Workspace 5" } },
  { "<main-6>", dsp.focus({ workspace = 6 }),       { desc = "Workspace 6" } },
  { "<main-7>", dsp.focus({ workspace = 7 }),       { desc = "Workspace 7" } },
  { "<main-8>", dsp.focus({ workspace = 8 }),       { desc = "Workspace 8" } },
  { "<main-9>", dsp.focus({ workspace = 9 }),       { desc = "Workspace 9" } },
  { "<main-0>", dsp.focus({ workspace = 10 }),      { desc = "Workspace 10" } },
  { "<main-mut-1>", dsp.window.move({ workspace = 1 }),  { desc = "Move to workspace 1" } },
  { "<main-mut-2>", dsp.window.move({ workspace = 2 }),  { desc = "Move to workspace 2" } },
  { "<main-mut-3>", dsp.window.move({ workspace = 3 }),  { desc = "Move to workspace 3" } },
  { "<main-mut-4>", dsp.window.move({ workspace = 4 }),  { desc = "Move to workspace 4" } },
  { "<main-mut-5>", dsp.window.move({ workspace = 5 }),  { desc = "Move to workspace 5" } },
  { "<main-mut-6>", dsp.window.move({ workspace = 6 }),  { desc = "Move to workspace 6" } },
  { "<main-mut-7>", dsp.window.move({ workspace = 7 }),  { desc = "Move to workspace 7" } },
  { "<main-mut-8>", dsp.window.move({ workspace = 8 }),  { desc = "Move to workspace 8" } },
  { "<main-mut-9>", dsp.window.move({ workspace = 9 }),  { desc = "Move to workspace 9" } },
  { "<main-mut-0>", dsp.window.move({ workspace = 10 }), { desc = "Move to workspace 10" } },

  -- Scroll through existing workspaces
  { "<main-mouse_down>", dsp.focus({ workspace = "e+1" }), { desc = "Next workspace" } },
  { "<main-mouse_up>",   dsp.focus({ workspace = "e-1" }), { desc = "Previous workspace" } },

  -- Mouse drag/resize
  { "<main-mouse:272>", dsp.window.drag(),   { desc = "Move window", mouse = true } },
  { "<main-mouse:273>", dsp.window.resize(), { desc = "Resize window", mouse = true } },

  -- Empty workspace
  { "<main-W>",     dsp.focus({ workspace = "empty" }),         { desc = "Empty workspace" } },
  { "<main-mut-W>", dsp.window.move({ workspace = "empty" }),   { desc = "Move to empty workspace" } },

  -- Quickterm
  { "<main-T>",     dsp.workspace.toggle_special("quickterm"),  { desc = "Toggle quickterm" } },
  { "<main-mut-T>", dsp.window.move({ workspace = "special:quickterm" }), { desc = "Move to quickterm" } },

  -- Game workspace
  { "<main-G>",     dsp.focus({ workspace = "name:Game" }),     { desc = "Game workspace" } },
  { "<main-mut-G>", dsp.window.move({ workspace = "name:Game" }), { desc = "Move to game workspace" } },
})

-- ====================================================================
-- APPLICATION LAUNCH
-- ====================================================================

utils.set_binds({
  { "<main-R>", dsp.exec_cmd("tlgui launch"),         { desc = "Run launcher" } },
  { "<main-F>", dsp.exec_cmd("dolphin"),              { desc = "File manager" } },
  { "<main-Q>", dsp.exec_cmd("foot zellij-session-picker"), { desc = "Terminal" } },
  { "<main-B>", dsp.exec_cmd("firefox"),              { desc = "Browser" } },
  { "<main-C>", dsp.window.close(),                   { desc = "Close window" } },
})

-- ====================================================================
-- SCOPE NAVIGATION  — workspace ±1
-- ====================================================================

utils.set_binds({
  -- Scope nav: main + scope + left/right/h/l → workspace -1/+1
  { "<main-scope-h>",     dsp.focus({ workspace = -1 }), { desc = "Previous workspace" } },
  { "<main-scope-l>",     dsp.focus({ workspace = 1 }),  { desc = "Next workspace" } },
  { "<main-scope-left>",  dsp.focus({ workspace = -1 }), { desc = "Previous workspace" } },
  { "<main-scope-right>", dsp.focus({ workspace = 1 }),  { desc = "Next workspace" } },
})

-- ====================================================================
-- SCOPE MUTATION  — move window workspace ±1
-- ====================================================================

utils.set_binds({
  { "<main-scope-mut-h>",     dsp.window.move({ workspace = -1 }), { desc = "Move window left" } },
  { "<main-scope-mut-l>",     dsp.window.move({ workspace = 1 }),  { desc = "Move window right" } },
  { "<main-scope-mut-left>",  dsp.window.move({ workspace = -1 }), { desc = "Move window left" } },
  { "<main-scope-mut-right>", dsp.window.move({ workspace = 1 }),  { desc = "Move window right" } },
})

-- ====================================================================
-- SYSTEM / LAYOUT  — resize windows
-- ====================================================================

utils.set_binds({
  -- hjkl
  { "<main-sys-h>", dsp.window.resize({ w = "-20% 0" }), { desc = "Resize left" } },
  { "<main-sys-l>", dsp.window.resize({ w = "20% 0" }),  { desc = "Resize right" } },
  { "<main-sys-j>", dsp.window.resize({ w = "0 20%" }),  { desc = "Resize down" } },
  { "<main-sys-k>", dsp.window.resize({ w = "0 -20%" }), { desc = "Resize up" } },

  -- Arrow keys
  { "<main-sys-left>",  dsp.window.resize({ w = "-20% 0" }), { desc = "Resize left" } },
  { "<main-sys-right>", dsp.window.resize({ w = "20% 0" }),  { desc = "Resize right" } },
  { "<main-sys-down>",  dsp.window.resize({ w = "0 20%" }),  { desc = "Resize down" } },
  { "<main-sys-up>",    dsp.window.resize({ w = "0 -20%" }), { desc = "Resize up" } },
})

-- ====================================================================
-- UTILITIES
-- ====================================================================

utils.set_binds({
  -- Screenshot (slurp + grim)
  { "<main-sys-S>", dsp.exec_cmd("grim -g \"$(slurp)\""), { desc = "Screenshot region" } },

  -- Leader key: opens which-key leader menu
  { "<leader>", dsp.exec_cmd("tctl keys"), { desc = "Leader menu" } },
})
