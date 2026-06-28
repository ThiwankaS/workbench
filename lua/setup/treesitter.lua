local parsers = { "c", "cpp", "javascript", "python", "lua", "vim", "vimdoc", "bash", "json" }

require("nvim-treesitter").setup({
  highlight = { enable = true },
  indent = { enable = true },
})

vim.schedule(function()
  pcall(function()
    require("nvim-treesitter").install(parsers)
  end)
end)

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter_syntax", { clear = true }),
  pattern = { "c", "cpp", "javascript", "python" },
  callback = function(args)
    vim.bo[args.buf].syntax = ""
  end,
})
