require("telescope").setup({
  defaults = {
    prompt_prefix = "  ",
    selection_caret = "  ",
    sorting_strategy = "ascending",
    layout_config = { horizontal = { prompt_position = "top" } },
    mappings = {
      i = {
        -- Do not override Ctrl+j/k — global maps are normal-mode only;
        -- these keep preview scroll inside Telescope.
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
