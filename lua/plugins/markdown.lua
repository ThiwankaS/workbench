return {
  {
    -- Rich markdown preview plugin.
    "roerohan/mark.nvim",
    -- Load only for markdown buffers.
    ft = "markdown",
    -- Build TypeScript frontend needed by plugin.
    build = "cd typescript && bun install && bun run build",
    config = function()
      require("mark").setup({
        split_position = "right",
        split_size = 50,
        auto_start = false,
        theme = "GitHub Dark",
        mappings = {
          toggle_preview = "<leader>mp",
        },
      })
    end,
  },
}
