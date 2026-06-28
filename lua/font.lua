--- JetBrains Mono Nerd Font — GUI Neovim only; set the same face in your terminal.
local M = {}

M.name = "JetBrainsMono Nerd Font"
M.size = 14

function M.setup()
  if vim.g.ui_font then
    return
  end
  vim.g.ui_font = true
  vim.opt.guifont = string.format("%s:h%s", M.name, M.size)
end

return M
