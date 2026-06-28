require("nvim-web-devicons").setup({ default = true, strict = false })

local function tree_keys(bufnr)
  local api = require("nvim-tree.api")
  local map_opts = { buffer = bufnr, silent = true, nowait = true }

  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", { desc = desc }, map_opts))
  end

  -- Up/down: use Vim line motion (sibling.next breaks on the ".." row)
  map("<Down>", "j", "Tree: down")
  map("<Up>", "k", "Tree: up")

  -- Left/right: folder collapse / open
  map("<Left>", api.node.navigate.parent_close, "Tree: parent / close")
  map("<Right>", api.node.open.edit, "Tree: open / expand")
end

require("nvim-tree").setup({
  view = { width = 32, side = "left" },
  renderer = { group_empty = true, indent_markers = { enable = true } },
  filters = { dotfiles = false },
  actions = { open_file = { window_picker = { enable = false } } },
  on_attach = function(bufnr)
    require("nvim-tree.keymap").on_attach_default(bufnr)
    tree_keys(bufnr)
  end,
})

-- Re-apply if the tree buffer is recreated (reload, etc.)
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("workbench_nvim_tree", { clear = true }),
  pattern = "NvimTree",
  callback = function(args)
    tree_keys(args.buf)
  end,
})
