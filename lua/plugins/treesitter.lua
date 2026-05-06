local extra = {
  "asm",
  "bash",
  "c",
  "cmake",
  "cpp",
  "make",
  "markdown",
  "markdown_inline",
  "javascript",
  "typescript",
  "python",
  "json",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, extra)
      table.sort(opts.ensure_installed)
      opts.ensure_installed = vim.fn.uniq(opts.ensure_installed)
      return opts
    end,
  },
}
