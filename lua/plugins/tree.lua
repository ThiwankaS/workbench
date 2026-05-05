return {
  {
    -- File explorer sidebar.
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Buffer-local keymaps when tree window is active.
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
        -- Keep default mappings and add preferred overrides.
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
        -- Keep cursor position stable during tree updates.
        hijack_cursor = true,
        update_focused_file = {
          enable = true,
          update_root = false,
        },
        view = {
          -- Sidebar width.
          width = 36,
        },
      })

      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle explorer" })
      vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Find current file in explorer" })
    end,
  },
}
