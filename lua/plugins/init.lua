return {
  {
    "stevearc/conform.nvim",
    opts = require("configs.conform"),
  },

  -- NvChad bundles cmp + LuaSnip here; we use blink.cmp instead (`lua/plugins/blink.lua`).
  { "hrsh7th/nvim-cmp", enabled = false },

  -- Extends NvChad's nvim-treesitter / nvim-lspconfig specs; `config` runs after NvChad's so LSP hooks apply.
  {
    "neovim/nvim-lspconfig",
    priority = 45,
    dependencies = { "saghen/blink.cmp" },
    config = function()
      require("configs.lspconfig")
    end,
  },
}
