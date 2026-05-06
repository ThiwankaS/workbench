local theme = require("config.theme")

local M = {}

M.base46 = {
  transparency = true,
  theme = "gruvbox",
  hl_override = theme.hl_override(),
}

return M
