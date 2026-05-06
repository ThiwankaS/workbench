return {
  {
    "stevearc/conform.nvim",
    opts = require("configs.conform"),
  },

  -- Extends NvChad's nvim-treesitter / nvim-lspconfig specs; `config` runs after NvChad's so LSP hooks apply.
  {
    "neovim/nvim-lspconfig",
    priority = 45,
    config = function()
      require("configs.lspconfig")
    end,
  },
}
