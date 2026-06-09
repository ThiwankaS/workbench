return {
  {
    "nvim-tree/nvim-tree.lua",
    priority = 1000,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
        api.config.mappings.default_on_attach(bufnr)
        local opts = function(desc)
          return { buffer = bufnr, noremap = true, silent = true, nowait = true, desc = "tree: " .. desc }
        end
        vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close parent"))
        vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse all"))
      end

      require("nvim-tree").setup({
        on_attach = on_attach,
        hijack_cursor = true,
        update_focused_file = { enable = true, update_root = false },
        view = { width = 36 },
      })
    end,
  },
}
