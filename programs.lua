-- programs.lua — Application paths (from settings)

local settings = require("settings")

local M = {}

M.terminal = settings.programs.terminal
M.quickterm = settings.programs.quickterm
M.file_manager = settings.programs.file_manager
M.browser = settings.programs.browser

return M
