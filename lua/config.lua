--- User-editable settings. Restart Neovim after changes.
--- Everything else lives in lua/setup/ and lua/core/ — edit here only for paths and toggles.
return {
  --- Obsidian vault for `Space sn` architecture notes.
  --- Set to nil or "" to disable obsidian.nvim (preview and aerial still work).
  obsidian_vault = vim.fn.expand("~/Documents/Obsidian/Main"),

  --- Filetypes that support `Space mp` markdown/PlantUML preview (markdown-preview.nvim).
  --- Typst (.typ) uses the same key via typst-preview.nvim — see setup/typst_preview.lua.
  preview_filetypes = { "markdown", "plantuml" },

  --- Mason packages to install on first run (see lua/setup/lsp.lua).
  lsp_servers = {
    "clangd",
    "typescript-language-server",
    "pyright",
    "dockerfile-language-server",
    "neocmakelsp", -- CMake (LSP name: neocmake)
    "qmlls", -- QML (system Arch alternative: qt6-languageserver → qmlls6)
    "tinymist", -- Typst (PATH binary ~/.local/bin/tinymist preferred)
    "harper-ls", -- English grammar in markdown / gitcommit / text / Typst
  },
}
