-- mods.lua — Modifier and alias definitions

local M = {}

M.main_mod = "SUPER"
M.mut_mod = "SHIFT"
M.scope_mod = "CTRL"
M.sys_mod = "ALT"
M.leader = "SUPER + SPACE"

-- Aliases for the bind system: <alias-key> → resolved modifier string
M.aliases = {
  main   = M.main_mod,
  mut    = M.mut_mod,
  scope  = M.scope_mod,
  sys    = M.sys_mod,
  leader = M.leader,
}

return M
