--- File tree sidebar (nvim-tree).
local M = {}

function M.setup()
  require("nvim-web-devicons").setup({ default = true, strict = false })

  require("nvim-tree").setup({
    view = {
      width = 32,
      side = "left",
      relativenumber = false,
    },
    renderer = {
      group_empty = true,
      highlight_git = false,
      indent_markers = { enable = true },
    },
    filters = {
      dotfiles = false,
    },
    actions = {
      open_file = {
        window_picker = { enable = false },
      },
    },
  })
end

return M
