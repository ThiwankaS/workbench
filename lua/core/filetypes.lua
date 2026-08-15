--- Shared filetype lists — single source of truth for maps and LSP.
local M = {}

--- Skip global leader maps (tree, Telescope pickers, Mason UI, etc.).
M.ui_plugin = {
  NvimTree = true,
  TelescopePrompt = true,
  TelescopeResults = true,
  spectre_panel = true,
  DressingInput = true,
  mason = true,
}

--- Skip buffer-local LSP maps (help, plugin UIs).
M.lsp_skip = {
  NvimTree = true,
  TelescopePrompt = true,
  TelescopeResults = true,
  help = true,
  lazy = true,
  mason = true,
}

--- Treesitter: disable legacy syntax highlighting for these (use TS only).
M.treesitter_lang = { "c", "cpp", "javascript", "python" }

return M
