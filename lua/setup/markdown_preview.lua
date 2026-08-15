--- Browser preview for .md / .puml (Mermaid, PlantUML via plantuml.com).
--- configure() runs before vim.pack.add; register_commands() after plugins load.
local config = require("config")
local M = {}

local function previewable()
  local ft = vim.bo.filetype
  for _, name in ipairs(config.preview_filetypes) do
    if ft == name then
      return true
    end
  end
  return false
end

local function ensure_loaded()
  vim.cmd.packadd("markdown-preview.nvim")
  return type(vim.fn["mkdp#util#toggle_preview"]) == "function"
end

--- Set vim.g.mkdp_* before markdown-preview.nvim plugin/mkdp.vim loads.
function M.configure()
  vim.g.mkdp_auto_start = 0
  vim.g.mkdp_auto_close = 1
  vim.g.mkdp_filetypes = config.preview_filetypes
  vim.g.mkdp_echo_preview_url = 1
  vim.g.mkdp_preview_options = {
    uml = {
      server = "https://www.plantuml.com/plantuml",
      imageFormat = "svg",
    },
  }
end

function M.install()
  vim.cmd.packadd("markdown-preview.nvim")
  if type(vim.fn["mkdp#util#install_sync"]) ~= "function" then
    vim.notify("markdown-preview.nvim missing — run :lua vim.pack.update()", vim.log.levels.ERROR)
    return false
  end
  vim.fn["mkdp#util#install_sync"](true)
  return true
end

function M.toggle()
  if not previewable() then
    vim.notify("Open a .md or .puml file, then Space mp", vim.log.levels.WARN)
    return
  end
  if not ensure_loaded() then
    vim.notify("markdown-preview.nvim missing — run :MarkdownPreviewInstall", vim.log.levels.ERROR)
    return
  end
  vim.fn["mkdp#util#toggle_preview"]()
end

function M.register_commands()
  vim.api.nvim_create_user_command("MarkdownPreviewInstall", function()
    M.install()
  end, { desc = "Download markdown-preview server binary" })
end

return M
