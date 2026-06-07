--- NvChad user config (loaded as `nvconfig` by base46).
--- UI tweaks live here; syntax colors live in `lua/config/theme.lua`.
local theme = require("config.theme")

local M = {}

M.base46 = {
  transparency = true,
  theme = "gruvbox",
  hl_override = theme.hl_override(),
}

M.ui = {
  statusline = {
    order = {
      "mode",
      "file",
      "git",
      "%=",
      "lsp_msg",
      "%=",
      "diagnostics",
      "lsp",
      "cwd",
      "clock",
      "cursor",
    },
    modules = {
      clock = function()
        return "%#St_cwd_text#  " .. os.date("%H:%M") .. " "
      end,
    },
  },
}

return M
