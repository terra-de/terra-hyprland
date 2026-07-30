-- programs.lua — Application paths (from settings and system defaults)

local settings = require("settings")

local M = {}

M.terminal = settings.programs.terminal
M.quickterm = settings.programs.quickterm
M.file_manager = settings.programs.file_manager

-- Browser: resolve at execution time via shell pipeline:
--   $BROWSER  →  xdg-settings (parse .desktop Exec=)  →  settings.programs.browser
-- Uses only POSIX sh built-ins (while read, parameter expansion) — no Lua io.
local browser_fallback = settings.programs.browser
M.browser = [[c="${BROWSER:-$(xdg-settings get default-web-browser 2>/dev/null)}"; case "${c##*.}" in desktop) for d in "${XDG_DATA_HOME:-$HOME/.local/share}/applications/$c" "/usr/share/applications/$c" "/usr/local/share/applications/$c"; do [ -f "$d" ] || continue; while IFS='=' read -r k v; do [ "$k" = "Exec" ] || continue; v="${v%%%*}"; c="${v%% *}"; break; done < "$d"; break; done; c="${c%.desktop}"; esac; ]] .. [[${c:-]] .. browser_fallback .. [[}]]

return M
