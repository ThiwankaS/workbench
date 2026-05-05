return {
  {
    -- Minimap for quick visual navigation in long files.
    "echasnovski/mini.map",
    version = false,
    config = function()
      local map = require("mini.map")
      map.setup()
      vim.keymap.set("n", "<leader>mo", map.open, { desc = "Open minimap" })
      vim.keymap.set("n", "<leader>mc", map.close, { desc = "Close minimap" })
    end,
  },
}
