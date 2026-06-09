--- Core overrides for NvChad-bundled plugins (lazy.nvim merges by plugin name).
return {
  { "hrsh7th/nvim-cmp", enabled = false },

  {
    "stevearc/conform.nvim",
    opts = require("configs.conform"),
  },

  {
    "neovim/nvim-lspconfig",
    priority = 1000,
    lazy = false,
    event = false,
    config = function()
      require("configs.lspconfig").setup()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    priority = 1000,
    lazy = false,
    event = false,
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
