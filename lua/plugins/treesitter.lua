--- nvim-treesitter v2 — sole owner spec (overrides NvChad BufReadPost + TSInstallAll build).
local parsers = {
  "asm",
  "bash",
  "c",
  "cmake",
  "cpp",
  "javascript",
  "json",
  "lua",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "python",
  "printf",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
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

      vim.schedule(function()
        pcall(function()
          require("nvim-treesitter").install(parsers)
        end)
      end)
    end,
  },
}
