return {
  {
    -- Treesitter provides accurate syntax tree parsing.
    "nvim-treesitter/nvim-treesitter",
    -- Keep parsers updated when plugin updates.
    build = ":TSUpdate",
    opts = {
      -- Parsers to ensure are available.
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "lua",
        "markdown",
        "markdown_inline",
        "vim",
        "vimdoc",
        "javascript",
        "typescript",
        "python",
        "json",
        "yaml",
      },
      -- Install missing parsers automatically.
      auto_install = true,
      -- Enable Treesitter-based syntax highlighting.
      highlight = { enable = true },
      -- Enable Treesitter indentation where supported.
      indent = { enable = true },
    },
    config = function(_, opts)
      -- Guard against load errors and fail gracefully.
      local ok, treesitter = pcall(require, "nvim-treesitter")
      if not ok then
        vim.notify("nvim-treesitter failed to load", vim.log.levels.ERROR)
        return
      end
      treesitter.setup(opts)
    end,
  },
}
