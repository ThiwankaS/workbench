--- Core plugin overrides (imported from init.lua `{ import = "plugins" }`).
return {
  {
    "stevearc/conform.nvim",
    opts = require("configs.conform"),
  },

  { "hrsh7th/nvim-cmp", enabled = false }, -- replaced by blink.cmp

  {
    "neovim/nvim-lspconfig",
    priority = 45,
    dependencies = { "saghen/blink.cmp" },
    config = function()
      require("configs.lspconfig")
    end,
  },
}
