--- nvim-treesitter v2 — focused parsers for C/C++, TS/JS, Markdown (+ config editing).
local parsers = {
  "bash",
  "c",
  "cpp",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "typescript",
  "vim",
  "vimdoc",
}

local install_dir = vim.fs.normalize(vim.fn.stdpath("data") .. "/site")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    priority = 1000,
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({ install_dir = install_dir })

      pcall(function()
        dofile(vim.g.base46_cache .. "treesitter")
      end)

      pcall(function()
        require("nvim-treesitter").install(parsers)
      end)
    end,
  },
}
