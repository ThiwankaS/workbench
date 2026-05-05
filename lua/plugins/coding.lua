return {
  {
    -- Fast comment toggling (gcc / gc in visual mode).
    "numToStr/Comment.nvim",
    opts = {},
  },
  {
    -- Auto-close brackets, quotes, and pairs.
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    -- Move lines/selections with Alt+j / Alt+k.
    "echasnovski/mini.move",
    version = false,
    opts = {},
    config = function(_, opts)
      require("mini.move").setup(opts)
      vim.keymap.set("n", "<A-j>", "<cmd>lua MiniMove.move_line('down')<CR>", { desc = "Move line down" })
      vim.keymap.set("n", "<A-k>", "<cmd>lua MiniMove.move_line('up')<CR>", { desc = "Move line up" })
      vim.keymap.set("v", "<A-j>", "<cmd>lua MiniMove.move_selection('down')<CR>", { desc = "Move selection down" })
      vim.keymap.set("v", "<A-k>", "<cmd>lua MiniMove.move_selection('up')<CR>", { desc = "Move selection up" })
    end,
  },
}
