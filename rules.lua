-- rules.lua — Window rules and layer rules

-- Suppress maximize requests from all apps
hl.window_rule({
  name = "suppress-maximize",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Fullscreen on game windows
hl.window_rule({ match = { class = "steam_app*" }, fullscreen = true })
hl.window_rule({ match = { class = "factorio*" }, fullscreen = true })
hl.window_rule({ match = { class = "Terraria*" }, fullscreen = true })

-- No animations on Quickshell layers
hl.layer_rule({
  match = { namespace = "^quickshell(.*)?$" },
  no_anim = true,
})

-- No animations on slurp/grim selection overlay
hl.layer_rule({
  match = { namespace = "selection" },
  no_anim = true,
})

-- On-screen keyboard slides up from bottom
hl.layer_rule({
  match = { namespace = "wvkbd" },
  animation = "slide bottom",
})
