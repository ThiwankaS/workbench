return {
  {
    "echasnovski/mini.map",
    version = false,
    keys = {
      {
        "<leader>mo",
        function()
          require("mini.map").open()
        end,
        desc = "Open minimap",
      },
      {
        "<leader>mc",
        function()
          require("mini.map").close()
        end,
        desc = "Close minimap",
      },
    },
    config = function()
      require("mini.map").setup()
    end,
  },
}
