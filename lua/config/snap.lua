--- snap.nvim settings aligned with NvChad base46 (Gruvbox) + JetBrainsMono Nerd Font.
local M = {}

local BIN_DIR = vim.fn.stdpath("data") .. "/snap.nvim/bin"

local FONT_DIR = vim.fn.expand("~/.local/share/fonts/JetBrainsMonoNerd")
local FONT_NAME = "JetBrainsMono Nerd Font"

local function font_file(filename)
  local path = FONT_DIR .. "/" .. filename
  if vim.uv.fs_stat(path) then
    return path
  end
  return nil
end

--- Active base46 palette (falls back when Normal has no bg with transparency).
local function palette()
  local ok_chad, chadrc = pcall(require, "chadrc")
  local theme_name = ok_chad and chadrc.base46 and chadrc.base46.theme or "gruvbox"
  local ok_theme, theme = pcall(require, "base46.themes." .. theme_name)
  if ok_theme and theme.base_30 then
    return theme.base_30, theme.base_16
  end
  return nil, nil
end

local function hex_color(value, fallback)
  if type(value) == "number" then
    return string.format("#%06x", value)
  end
  return fallback
end

--- Background/foreground used when buffer highlights omit bg (NvChad transparency).
function M.editor_bg()
  local hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  if hl.bg then
    return hex_color(hl.bg, "#282828")
  end
  local base_30 = select(1, palette())
  return base_30 and (base_30.black or base_30.darker_black) or "#282828"
end

function M.editor_fg()
  local hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  if hl.fg then
    return hex_color(hl.fg, "#ebdbb2")
  end
  local base_30, base_16 = palette()
  if base_30 and base_30.white then
    return base_30.white
  end
  if base_16 and base_16.base05 then
    return base_16.base05
  end
  return "#ebdbb2"
end

--- Patch snap highlight helpers so transparent themes still export Gruvbox bg/fg.
function M.patch_highlights()
  local utils = require("snap.highlights.utils")
  utils.get_default_bg = M.editor_bg
  utils.get_default_fg = M.editor_fg
end

function M.backend_incomplete()
  return vim.fn.isdirectory(BIN_DIR .. "/node_modules/playwright-core") == 0
end

function M.notify_backend_missing(level)
  if not M.backend_incomplete() then
    return
  end
  vim.notify(
    "snap.nvim backend incomplete — run: " .. vim.fn.stdpath("config") .. "/scripts/install_snap_backend.sh",
    level or vim.log.levels.WARN,
    { title = "snap.nvim" }
  )
end

function M.install_script()
  return vim.fn.stdpath("config") .. "/scripts/install_snap_backend.sh"
end

function M.font_settings()
  return {
    -- Match terminal point size (adjust here if snapshots look too large/small).
    size = vim.g.snap_font_size or 14,
    line_height = vim.g.snap_font_line_height or 1.0,
    fonts = {
      default = {
        name = FONT_NAME,
        file = font_file("JetBrainsMonoNerdFont-Regular.ttf"),
      },
      bold = {
        name = FONT_NAME,
        file = font_file("JetBrainsMonoNerdFont-Bold.ttf"),
      },
      italic = {
        name = FONT_NAME,
        file = font_file("JetBrainsMonoNerdFont-Italic.ttf"),
      },
      bold_italic = {
        name = FONT_NAME,
        file = font_file("JetBrainsMonoNerdFont-BoldItalic.ttf"),
      },
    },
  }
end

function M.opts()
  return {
    template = "default",
    output_dir = vim.fn.expand("~/Pictures/Screenshots"),
    filename_pattern = "snap_%file_name_%t",
    timeout = 60000,
    log_level = "warn",
    save_to_disk = {
      image = true,
      html = false,
    },
    copy_to_clipboard = {
      image = true,
      html = false,
    },
    font_settings = M.font_settings(),
  }
end

return M
