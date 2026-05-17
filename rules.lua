-- rules.lua — Window rules and layer rules (from settings)

local settings = require("settings")

-- ====================================================================
-- WINDOW RULES
-- ====================================================================

-- Suppress maximize requests from all apps
if settings.window_rules.suppress_maximize then
  hl.window_rule({
    name = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
  })
end

-- Fullscreen on game windows
for _, class in ipairs(settings.window_rules.fullscreen_classes) do
  hl.window_rule({ match = { class = class }, fullscreen = true })
end

-- Additional window rules from settings
for _, rule in ipairs(settings.window_rules.additional) do
  hl.window_rule(rule)
end

-- ====================================================================
-- LAYER RULES
-- ====================================================================

-- No animations on certain namespace patterns
for _, ns in ipairs(settings.layer_rules.no_anim_namespaces) do
  hl.layer_rule({
    match = { namespace = ns },
    no_anim = true,
  })
end

-- Animation overrides (e.g. OSK slides up from bottom)
for _, override in ipairs(settings.layer_rules.animation_overrides) do
  hl.layer_rule({
    match = { namespace = override.namespace },
    animation = override.animation,
  })
end
