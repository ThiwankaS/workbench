return {
  {
    -- Catppuccin theme.
    "catppuccin/nvim",
    name = "catppuccin",
    -- Load early so other plugins can inherit colors.
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        -- Dark flavor.
        flavour = "mocha",
        -- Respect terminal background transparency.
        transparent_background = true,
        integrations = {
          cmp = true,
          mason = true,
          nvimtree = true,
          telescope = true,
          treesitter = true,
          which_key = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
