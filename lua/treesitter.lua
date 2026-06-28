--- Treesitter — parsers, highlighting, indent.
local M = {}

M.parsers = { "c", "cpp", "javascript", "python", "asm", "lua", "vim", "vimdoc", "bash", "json" }

M.syntax_off = { "c", "cpp", "javascript", "python", "asm", "nasm", "gas" }

function M.setup()
  require("nvim-treesitter").setup({
    highlight = { enable = true },
    indent = { enable = true },
  })

  vim.schedule(function()
    pcall(function()
      require("nvim-treesitter").install(M.parsers)
    end)
  end)

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter_syntax", { clear = true }),
    pattern = M.syntax_off,
    callback = function(args)
      vim.bo[args.buf].syntax = ""
    end,
  })
end

return M
