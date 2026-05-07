return {
  {
    -- Fuzzy finder for files, text, buffers, commands.
    "nvim-telescope/telescope.nvim",
    -- Stable release branch for Telescope 0.1 API.
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
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
        "<leader>cW",
        function()
          local file = vim.fn.expand("%:p:h")
          if file ~= "" then
            vim.cmd("cd " .. file)
            vim.notify("Global cwd → " .. file)
          end
        end,
        desc = "cd (global) to current file dir",
      },
    },
    -- Telescope UI and picker defaults.
    config = function()
      -- Compatibility shims for nvim-treesitter + Telescope 0.1.x previewers.
      local ok_parsers, parsers = pcall(require, "nvim-treesitter.parsers")
      if ok_parsers then
        if type(parsers.ft_to_lang) ~= "function" then
          parsers.ft_to_lang = function(ft)
            return vim.treesitter.language.get_lang(ft) or ft
          end
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
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      pcall(telescope.load_extension, "fzf")

      -- Telescope still uses removed `nvim-treesitter.configs` / `parsers.get_parser`.
      -- `config/ts_compat.lua` fixes configs; replace the preview highlighter with core APIs.
      local preview_utils = require("telescope.previewers.utils")
      preview_utils.ts_highlighter = function(bufnr, ft)
        if not ft or ft == "" then
          return false
        end
        local lang = vim.treesitter.language.get_lang(ft) or ft
        local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang, { error = false })
        if not ok or parser == nil then
          return false
        end
        ok = pcall(function()
          vim.treesitter.highlighter.new(parser)
        end)
        return ok
      end
    end,
  },
}
