return {
  {
    -- Fuzzy finder for files, text, buffers, commands.
    "nvim-telescope/telescope.nvim",
    -- Stable release branch for Telescope 0.1 API.
    branch = "0.1.x",
    -- Lua utility library required by Telescope.
    dependencies = { "nvim-lua/plenary.nvim" },
    -- Lazy key bindings that load Telescope on first use.
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      {
        "<leader>fc",
        function()
          local builtin = require("telescope.builtin")
          local themes = require("telescope.themes")
          builtin.commands(themes.get_dropdown({ previewer = false }))
        end,
        desc = "Command palette",
      },
      {
        "<leader>:",
        function()
          local builtin = require("telescope.builtin")
          local themes = require("telescope.themes")
          builtin.command_history(themes.get_dropdown({ previewer = false }))
        end,
        desc = "Command history",
      },
      {
        "<leader>cd",
        function()
          local file = vim.fn.expand("%:p:h")
          if file ~= "" then
            vim.cmd("cd " .. file)
            vim.notify("Root set to " .. file)
          end
        end,
        desc = "Sync root to current file",
      },
    },
    -- Telescope UI and picker defaults.
    config = function()
      -- Compatibility shim:
      -- New nvim-treesitter versions removed parsers.ft_to_lang, but Telescope previewer
      -- still calls it in some releases. Re-create it safely to avoid runtime errors.
      local ok_parsers, parsers = pcall(require, "nvim-treesitter.parsers")
      if ok_parsers and type(parsers.ft_to_lang) ~= "function" then
        parsers.ft_to_lang = function(ft)
          return vim.treesitter.language.get_lang(ft) or ft
        end
      end

      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          -- Auto-switch between horizontal/vertical based on space.
          layout_strategy = "flex",
          layout_config = {
            horizontal = { prompt_position = "top", width = 0.90, height = 0.85 },
            vertical = { width = 0.90, height = 0.90 },
          },
          sorting_strategy = "ascending",
          -- Slight transparency for floating windows.
          winblend = 5,
        },
        pickers = {
          -- Use compact dropdown style for command list.
          commands = { theme = "dropdown" },
        },
      })
    end,
  },
}
