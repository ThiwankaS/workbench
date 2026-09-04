--- Sync Visual / search highlights with ~/.config/themes/current_theme (desktop palette).
local M = {}

local THEMES_DIR = vim.fn.expand("~/.config/themes")

local function read_current_theme_key()
  local file = THEMES_DIR .. "/current_theme"
  if vim.fn.filereadable(file) == 0 then
    return "gruvbox"
  end
  return vim.trim(vim.fn.readfile(file)[1] or "gruvbox")
end

local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

local function mix(a, b, t)
  local ar, ag, ab = hex_to_rgb(a)
  local br, bg, bb = hex_to_rgb(b)
  local r = math.floor(ar + (br - ar) * t + 0.5)
  local g = math.floor(ag + (bg - ag) * t + 0.5)
  local b_ = math.floor(ab + (bb - ab) * t + 0.5)
  return string.format("#%02x%02x%02x", r, g, b_)
end

local function load_theme_json(key)
  local path = THEMES_DIR .. "/" .. key .. ".json"
  if vim.fn.filereadable(path) == 0 then
    return nil
  end
  local raw = table.concat(vim.fn.readfile(path), "\n")
  local ok, decoded = pcall(vim.json.decode, raw)
  if not ok or type(decoded) ~= "table" then
    return nil
  end
  return decoded
end

function M.apply()
  local key = read_current_theme_key()
  local theme = load_theme_json(key)
  if not theme then
    return
  end

  local bg = theme.bg or "#1e1e2e"
  local fg = theme.fg or "#cdd6f4"
  local accent = theme.accent or "#cba6f7"
  local surface = theme.surface or "#181825"
  local visual_bg = mix(accent, surface, 0.42)
  local search_bg = mix(accent, surface, 0.55)

  local groups = {
    Visual = { bg = visual_bg, fg = fg },
    VisualNOS = { bg = visual_bg, fg = fg },
    Search = { bg = search_bg, fg = fg },
    IncSearch = { bg = accent, fg = bg, bold = true },
    CurSearch = { bg = accent, fg = bg, bold = true },
    Substitute = { bg = accent, fg = bg },
    PmenuSel = { bg = visual_bg, fg = fg, bold = true },
    TelescopeSelection = { bg = visual_bg, fg = fg, bold = true },
  }

  for name, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, name, spec)
  end
end

return M
