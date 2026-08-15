--- Telescope defaults. Ctrl+j/k scroll pickers; global Alt+j/k stay normal-mode only.
local M = {}

function M.setup()
  require("telescope").setup({
    defaults = {
      prompt_prefix = "  ",
      selection_caret = "  ",
      sorting_strategy = "ascending",
      layout_config = { horizontal = { prompt_position = "top" } },
      mappings = {
        i = {
          ["<C-j>"] = require("telescope.actions").move_selection_next,
          ["<C-k>"] = require("telescope.actions").move_selection_previous,
          ["<Down>"] = require("telescope.actions").move_selection_next,
          ["<Up>"] = require("telescope.actions").move_selection_previous,
        },
        n = {
          ["<Down>"] = require("telescope.actions").move_selection_next,
          ["<Up>"] = require("telescope.actions").move_selection_previous,
        },
      },
    },
  })
end

return M
