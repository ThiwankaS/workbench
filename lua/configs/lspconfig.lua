-- NvChad starts LSP asynchronously; defer so `defaults()` hooks are registered first.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.defer_fn(function()
      vim.lsp.enable({
        "clangd",
        "ts_ls",
        "pyright",
        "bashls",
        "marksman",
      })
    end, 250)
  end,
})
