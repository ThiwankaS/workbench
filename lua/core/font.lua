--- JetBrains Mono Nerd Font (GUI Neovim). Set the same face in your terminal.
local M = {}

local DEFAULT_SIZE = 14

local function parse_size()
  local face = vim.o.guifont
  local size = face:match(":h(%d+)")
  return tonumber(size) or DEFAULT_SIZE
end

local function set_size(size)
  vim.o.guifont = string.format("JetBrainsMono Nerd Font:h%d", size)
end

function M.zoom(delta)
  set_size(math.max(8, parse_size() + delta))
end

function M.reset()
  set_size(DEFAULT_SIZE)
end

set_size(DEFAULT_SIZE)

return M
