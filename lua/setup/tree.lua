--- nvim-tree file sidebar. Arrow keys for navigation; Space e/j are global maps.
local M = {}

local function tree_keys(bufnr)
  local api = require("nvim-tree.api")
  local map_opts = { buffer = bufnr, silent = true, nowait = true }

  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", { desc = desc }, map_opts))
  end

  map("<Down>", "j", "Tree: down")
  map("<Up>", "k", "Tree: up")
  map("<Left>", api.node.navigate.parent_close, "Tree: parent / close")
  map("<Right>", api.node.open.edit, "Tree: open / expand")
end

function M.setup()
  require("nvim-web-devicons").setup({ default = true, strict = false })

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

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("workbench_nvim_tree", { clear = true }),
    pattern = "NvimTree",
    callback = function(args)
      tree_keys(args.buf)
    end,
  })
end

return M
