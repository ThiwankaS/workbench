--- Markdown preview in browser (Mermaid diagrams in ```mermaid fences).
--- First install runs mkdp#util#install (downloads preview assets).
local M = {}

function M.install()
  if vim.fn.exists("*mkdp#util#install") == 2 then
    vim.fn["mkdp#util#install"]()
  end
end

function M.setup()
  vim.g.mkdp_auto_start = 0
  vim.g.mkdp_auto_close = 1
  vim.g.mkdp_filetypes = { "markdown" }
  vim.g.mkdp_preview_options = {
    mermaid = true,
    sync_scroll = 1,
  }

  vim.schedule(M.install)
end

return M
