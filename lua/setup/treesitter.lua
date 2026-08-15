--- Treesitter parsers, highlight, and legacy syntax disable for LSP languages.
local ft = require("core.filetypes")
local M = {}

local parsers = {
  "c",
  "cpp",
  "javascript",
  "python",
  "lua",
  "vim",
  "vimdoc",
  "bash",
  "json",
  "markdown",
  "markdown_inline",
}

function M.setup()
  require("nvim-treesitter").setup({
    highlight = { enable = true },
    indent = { enable = true },
  })

  vim.schedule(function()
    pcall(function()
      require("nvim-treesitter").install(parsers)
    end)
  end)

  -- Disable legacy syntax for languages where TS + LSP share highlighting duty.
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter_syntax", { clear = true }),
    pattern = ft.treesitter_lang,
    callback = function(args)
      vim.bo[args.buf].syntax = ""
    end,
  })
end

return M
