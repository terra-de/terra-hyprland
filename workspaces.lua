-- workspaces.lua — Special workspace rules

local programs = require("programs")

-- Quickterm scratchpad
hl.workspace_rule({
  workspace = "special:quickterm",
  on_created_empty = programs.quickterm,
  gaps_out = { 150, 30, 0, 30 },
})
