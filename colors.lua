-- colors.lua — Read Terra DE v2 palette from ~/.config/terra/palette.json
--
-- Always returns a complete color table. If palette.json is missing or a key
-- is absent, we fill from built-in defaults (v2 dark purple palette).
-- Hex colors (#rrggbb) are converted to Hyprland format (rgb(rrggbb)).

-- Default fallback — v2 dark purple palette (matches terratheme's dark mode)
local DEFAULTS = {
    bottom    = "#0d080a",
    low       = "#1f1419",
    base      = "#39232d",
    high      = "#583747",
    top       = "#7e4e65",
    standard  = "#ebe9ea",
    muted     = "#b8b3b6",
    c0        = "#69374f",
    on_c0     = "#d9d9d9",
    c1        = "#874878",
    on_c1     = "#d9d9d9",
    c2        = "#906694",
    on_c2     = "#311b2f",
    c3        = "#ae7ba9",
    on_c3     = "#2f1b31",
    c4        = "#c1a1c5",
    on_c4     = "#351826",
    error     = "#e10b10",
    on_error  = "#d7ced5",
    outline   = "#735965",
    ansi_0    = "#39232d",
    ansi_1    = "#fc484a",
    ansi_2    = "#2ffb2f",
    ansi_3    = "#cdc118",
    ansi_4    = "#837cf3",
    ansi_5    = "#dc4dde",
    ansi_6    = "#11dce5",
    ansi_7    = "#d7c9d9",
    ansi_8    = "#583747",
    ansi_9    = "#feb6b7",
    ansi_10   = "#9dfd9d",
    ansi_11   = "#ede468",
    ansi_12   = "#c9c7fa",
    ansi_13   = "#efabef",
    ansi_14   = "#72eff5",
    ansi_15   = "#e9e1ea",
}

-- Tiny JSON decoder: sandboxed load() — safe because we control the source.
local function parse_json(s)
    local fn, err = load("return " .. s, "=palette.json", "t", {})
    if not fn then return nil, err end
    local ok, result = pcall(fn)
    if not ok then return nil, result end
    return result
end

-- Convert any color string to rgb(rrggbb) format.
-- Handles: #rrggbb → rgb(rrggbb), rgb(...) → pass through.
local function to_rgb(val)
    if type(val) ~= "string" then return val end
    -- Strip leading #
    local s = val:gsub("^#", "")
    -- If already rgb(...), check it's well-formed, otherwise pass through
    local prefix = s:match("^(%a+%()")
    if prefix then return val end
    return "rgb(" .. s .. ")"
end

-- Merge active mode palette from JSON into DEFAULTS, converting to rgb().
local function build(mode_data)
    local result = {}
    for k, default_val in pairs(DEFAULTS) do
        local v = mode_data[k] or default_val
        result[k] = to_rgb(v)
    end
    return result
end

-- Main load — runs at require time.
local home = os.getenv("HOME")
local path = home and (home .. "/.config/terra/palette.json")
local colors

if path then
    local f, err = io.open(path, "r")
    if f then
        local content = f:read("*a")
        f:close()
        local data, err = parse_json(content or "")
        if data then
            local mode = data.mode
            local mode_data = mode and data[mode]
            if mode_data then
                colors = build(mode_data)
            end
        end
    end
end

-- Fallback to full defaults if anything went wrong
if not colors then
    colors = build(DEFAULTS)
end

return colors
