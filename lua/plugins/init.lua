--- Core overrides for NvChad-bundled plugins (lazy.nvim merges by plugin name).
return {
  {
    "stevearc/conform.nvim",
    opts = require("configs.conform"),
  },

  { "hrsh7th/nvim-cmp", enabled = false },

  {
    "neovim/nvim-lspconfig",
    priority = 1000,
    config = function()
      require("configs.lspconfig").setup()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    priority = 1000,
    lazy = false,
  },

  {
    "nvim-telescope/telescope.nvim",
    priority = 1000,
  },

  {
    "nvim-tree/nvim-tree.lua",
    priority = 1000,
  },
}
