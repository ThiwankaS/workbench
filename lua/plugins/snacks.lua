return {
  {
    -- UI/performance utility collection.
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Better behavior for very large files.
      bigfile = { enabled = true },
      -- Startup dashboard.
      dashboard = { enabled = true },
      -- Notification UI.
      notifier = { enabled = true },
      -- Smooth scrolling helpers.
      scroll = { enabled = true },
      -- Fast open for quick single-file workflows.
      quickfile = { enabled = true },
      -- Picker helpers used by snacks features.
      picker = { enabled = true },
    },
  },
  {
    -- Lazygit integration inside Neovim.
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitCurrentFile",
      "LazyGitLog",
      "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "Lazygit" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<CR>", desc = "Lazygit current file" },
      { "<leader>gl", "<cmd>LazyGitLog<CR>", desc = "Lazygit log" },
      {
        "<leader>go",
        function()
          local url = vim.fn.system("git config --get remote.origin.url"):gsub("%s+$", "")
          if url == "" then
            vim.notify("No git remote found", vim.log.levels.WARN)
            return
          end
          url = url:gsub("^git@github.com:", "https://github.com/"):gsub("%.git$", "")
          vim.ui.open(url)
        end,
        desc = "Open repository in browser",
      },
    },
  },
}
