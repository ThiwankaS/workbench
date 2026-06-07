local theme = require("config.theme")

local M = {}

M.base46 = {
  transparency = true,
  theme = "gruvbox",
  hl_override = theme.hl_override(),
  integrations = { "semantic_tokens" },
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
