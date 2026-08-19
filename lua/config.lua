--- User-editable settings. Restart Neovim after changes.
--- Everything else lives in lua/setup/ and lua/core/ — edit here only for paths and toggles.
return {
  --- Obsidian vault for `Space sn` architecture notes.
  --- Set to nil or "" to disable obsidian.nvim (preview and aerial still work).
  obsidian_vault = vim.fn.expand("~/Documents/Obsidian/Main"),

  --- Filetypes that support `Space mp` browser preview (markdown-preview.nvim).
  preview_filetypes = { "markdown", "plantuml" },

  --- Mason packages to install on first run (see lua/setup/lsp.lua).
  lsp_servers = { "clangd", "typescript-language-server", "pyright", "dockerfile-language-server" },
}
