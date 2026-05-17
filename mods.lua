-- mods.lua — Modifier and alias definitions (from settings)

local settings = require("settings")

local M = {}

M.main_mod = settings.keys.modifiers.main
M.mut_mod = settings.keys.modifiers.mut
M.scope_mod = settings.keys.modifiers.scope
M.sys_mod = settings.keys.modifiers.sys
M.leader = settings.keys.leader

-- Aliases for the bind system: <alias-key> → resolved modifier string
M.aliases = {
  main   = M.main_mod,
  mut    = M.mut_mod,
  scope  = M.scope_mod,
  sys    = M.sys_mod,
  leader = M.leader,
}

return M
