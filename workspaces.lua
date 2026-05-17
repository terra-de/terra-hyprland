-- workspaces.lua — Workspace rules (from settings)

local settings = require("settings")
local programs = require("programs")

for _, rule in ipairs(settings.workspace_rules) do
  local opts = {
    workspace = rule.workspace,
  }

  if rule.on_created_empty then
    opts.on_created_empty = rule.on_created_empty
  end

  if rule.gaps_out then
    opts.gaps_out = {
      top = rule.gaps_out.top or 0,
      left = rule.gaps_out.left or 0,
      bottom = rule.gaps_out.bottom or 0,
      right = rule.gaps_out.right or 0,
    }
  end

  hl.workspace_rule(opts)
end
