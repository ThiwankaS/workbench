--- Git gutter signs in the sign column.
local M = {}

function M.setup()
  require("gitsigns").setup({
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "▎" },
    },
    signcolumn = true,
  })
end

return M
