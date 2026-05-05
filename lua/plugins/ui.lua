return {
  {
    -- Filetype icons used by tree, bufferline, and statusline.
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    -- Bottom statusline.
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
    config = function()
      -- Load Catppuccin lualine theme directly; fallback to "auto" if unavailable.
      local ok_theme, catppuccin_lualine = pcall(require, "catppuccin.utils.lualine")
      local lualine_theme = ok_theme and catppuccin_lualine("mocha") or "auto"

      require("lualine").setup({
        options = {
          theme = lualine_theme,
          globalstatus = true,
        },
      })
    end,
  },
  {
    -- Buffer tabline.
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({})
    end,
  },
  {
    -- Popup helper that shows available leader mappings.
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
