return {
  {
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
