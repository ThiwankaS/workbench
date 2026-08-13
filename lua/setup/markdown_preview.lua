--- Markdown preview in browser (Mermaid in ```mermaid fences).
--- Run :MarkdownPreviewInstall once to download the preview server binary.
local M = {}

local preview_filetypes = { markdown = true, plantuml = true }

local function is_previewable()
  return preview_filetypes[vim.bo.filetype] == true
end

local function ensure_loaded()
  vim.cmd.packadd("markdown-preview.nvim")
  return type(vim.fn["mkdp#util#toggle_preview"]) == "function"
end

function M.install()
  vim.cmd.packadd("markdown-preview.nvim")
  if type(vim.fn["mkdp#util#install_sync"]) ~= "function" then
    vim.notify("markdown-preview.nvim not found — run :lua vim.pack.update()", vim.log.levels.ERROR)
    return false
  end
  vim.fn["mkdp#util#install_sync"](true)
  return true
end

function M.toggle()
  if not is_previewable() then
    vim.notify("Open a .md or .puml file first, then Space mp", vim.log.levels.WARN)
    return
  end
  if not ensure_loaded() then
    vim.notify("markdown-preview.nvim not found — run :lua vim.pack.update()", vim.log.levels.ERROR)
    return
  end
  vim.fn["mkdp#util#toggle_preview"]()
end

function M.setup()
  vim.g.mkdp_auto_start = 0
  vim.g.mkdp_auto_close = 1
  vim.g.mkdp_filetypes = { "markdown", "plantuml" }
  vim.g.mkdp_echo_preview_url = 1
  vim.g.mkdp_preview_options = {
    uml = {
      server = "https://www.plantuml.com/plantuml",
      imageFormat = "svg",
    },
  }

  vim.api.nvim_create_user_command("MarkdownPreviewInstall", function()
    M.install()
  end, { desc = "Download markdown-preview server binary" })
end

return M
