local mods = require("mods")
local programs = require("programs")

-- Brightness up
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("tctl brightness down 5"), { locked = true, repeating = true })
-- Brightness down
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("tctl brightness up 5"), { locked = true, repeating = true })

-- Volume up
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)
-- Volume down
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)
-- Toggle mute
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true }
)
-- Toggle mic mute
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true }
)

-- Media
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Toggle OSK
hl.bind(mods.main_mod .. "+ V", hl.dsp.exec_cmd("terrashell ipc call keyboard toggle"))

-- Core nav - hjkl and arrow keys for window focus
hl.bind(mods.main_mod .. "+ h", hl.dsp.focus({ direction = "left" }))
hl.bind(mods.main_mod .. "+ h", hl.dsp.focus({ direction = "left" }))
hl.bind(mods.main_mod .. "+ j", hl.dsp.focus({ direction = "down" }))
hl.bind(mods.main_mod .. "+ k", hl.dsp.focus({ direction = "up" }))
hl.bind(mods.main_mod .. "+ left", hl.dsp.focus({ direction = "right" }))
hl.bind(mods.main_mod .. "+ down", hl.dsp.focus({ direction = "down" }))
hl.bind(mods.main_mod .. "+ up", hl.dsp.focus({ direction = "up" }))
hl.bind(mods.main_mod .. "+ right", hl.dsp.focus({ direction = "right" }))

-- Move windows
hl.bind(mods.main_mod .. " + " .. mods.mut_mod .. " + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mods.main_mod .. " + " .. mods.mut_mod .. " + j", hl.dsp.window.move({ direction = "down" }))
hl.bind(mods.main_mod .. " + " .. mods.mut_mod .. " + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mods.main_mod .. " + " .. mods.mut_mod .. " + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mods.main_mod .. " + " .. mods.mut_mod .. " + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mods.main_mod .. " + " .. mods.mut_mod .. " + down", hl.dsp.window.move({ direction = "down" }))
hl.bind(mods.main_mod .. " + " .. mods.mut_mod .. " + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mods.main_mod .. " + " .. mods.mut_mod .. " + right", hl.dsp.window.move({ direction = "right" }))

-- Number workspace nav
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mods.main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mods.main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces
hl.bind(mods.main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mods.main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows
hl.bind(mods.main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mods.main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Next empty workspace
hl.bind(mods.main_mod .. " + W", hl.dsp.focus({ workspace = "empty" }))
hl.bind(mods.main_mod .. " + " .. mods.mut_mod .. " + W", hl.dsp.window.move({ workspace = "empty" }))

-- Special terminal workspace
hl.bind(mods.main_mod .. " + T", hl.dsp.workspace.toggle_special("quickterm"))
hl.bind(
    mods.main_mod .. " + " .. mods.mut_mod .. " + T",
    hl.dsp.window.move({ workspace = "special:quickterm" })
)
hl.workspace_rule({ workspace = "special:quickterm", on_created_empty = programs.quickterm, gaps_out = { 150, 30, 0, 30 } })

-- File manager
--
