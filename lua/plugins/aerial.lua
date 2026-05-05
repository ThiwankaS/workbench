return {
  {
    -- Symbol outline sidebar for fast navigation in large files.
    "stevearc/aerial.nvim",
    opts = {
      -- Prefer treesitter for local symbol parsing (great for asm labels).
      backends = { "treesitter", "lsp", "markdown", "man" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>a", "<cmd>AerialToggle!<CR>", desc = "Toggle symbol outline" },
    },
  },
}
