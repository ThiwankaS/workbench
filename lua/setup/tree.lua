require("nvim-web-devicons").setup({ default = true, strict = false })

require("nvim-tree").setup({
  view = { width = 32, side = "left" },
  renderer = { group_empty = true, indent_markers = { enable = true } },
  filters = { dotfiles = false },
  actions = { open_file = { window_picker = { enable = false } } },
})
