return {
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Line moves (Alt+j / Alt+k). Pair insertion: `lua/plugins/autopairs.lua`.
  {
    "echasnovski/mini.move",
    version = false,
    keys = {
      {
        "<A-j>",
        function()
          require("mini.move").move_line("down")
        end,
        mode = "n",
        desc = "Move line down",
      },
      {
        "<A-k>",
        function()
          require("mini.move").move_line("up")
        end,
        mode = "n",
        desc = "Move line up",
      },
      {
        "<A-j>",
        function()
          require("mini.move").move_selection("down")
        end,
        mode = "x",
        desc = "Move selection down",
      },
      {
        "<A-k>",
        function()
          require("mini.move").move_selection("up")
        end,
        mode = "x",
        desc = "Move selection up",
      },
    },
    opts = {},
    config = function(_, opts)
      require("mini.move").setup(opts)
    end,
  },
}
