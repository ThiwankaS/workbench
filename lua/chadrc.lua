-- Must load before NvChad compiles palette into base46 caches.
require("config.theme")
local T = vim.theme.syntax

local M = {}

M.base46 = {
  transparency = true,
  theme = "catppuccin",
  hl_override = {
    ["@keyword.type.c"] = { fg = T.keyword_type or "lavender" },
    ["@keyword.type.cpp"] = { fg = T.keyword_type or "lavender" },
    ["@type.c"] = { fg = T.type or "yellow" },
    ["@type.cpp"] = { fg = T.type or "yellow" },
    ["@preproc.arg"] = { fg = T.preproc_arg or "peach" },
  },
}

return M
