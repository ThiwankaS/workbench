-- NvChad disables semantic tokens for every client for compatibility. Clangd uses them heavily for
-- readable highlighting (@lsp.type.* → hl groups). This handler duplicates NvChad's strip logic but
-- skips clangd. Loaded after NvChad's nvim-lspconfig config (lower Lazy priority) so it merges
-- into vim.lsp.config("*") and replaces only `on_init`; NvChad capabilities stay intact.
vim.lsp.config("*", {
  on_init = function(client, _)
    if client.name == "clangd" then
      return
    end
    if vim.fn.has("nvim-0.11") ~= 1 then
      if client.supports_method("textDocument/semanticTokens") then
        client.server_capabilities.semanticTokensProvider = nil
      end
    else
      if client:supports_method("textDocument/semanticTokens") then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end
  end,
})

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
