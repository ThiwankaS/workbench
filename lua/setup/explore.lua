--- Codebase exploration: outline, LSP structure pickers, markdown/Obsidian notes.
--- Set vault path once (pick one):
---   export OBSIDIAN_VAULT="$HOME/path/to/vault"
---   vim.g.obsidian_vault = "/path/to/vault"   in init.lua before require("setup.explore")
--- Project notes folder also works: vim.g.obsidian_vault = vim.fn.getcwd() .. "/docs"

local M = {}

local function vault_path()
  local path = vim.g.obsidian_vault or vim.env.OBSIDIAN_VAULT
  if path and path ~= "" then
    return vim.fn.expand(path)
  end
  return nil
end

function M.setup()
  require("aerial").setup({
    attach_mode = "global",
    backends = { "lsp", "treesitter", "markdown" },
    layout = {
      min_width = 26,
      max_width = 40,
      default_direction = "prefer_right",
    },
    filter = function(_, item)
      return item.kind ~= nil
    end,
  })

  require("render-markdown").setup({
    file_types = { "markdown", "obsidian" },
    heading = { enabled = true, sign = true },
    code = { enabled = true },
  })

  local vault = vault_path()
  if vault and vim.fn.isdirectory(vault) == 1 then
    require("obsidian").setup({
      workspaces = {
        { name = "main", path = vault },
      },
      notes_subdir = "notes",
      daily_notes = { folder = "daily", date_format = "%Y-%m-%d" },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      disable_frontmatter = false,
      mappings = {
        -- Keep global leader maps in core/keymaps.lua; Obsidian buffer-local only.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
      },
    })
    vim.g.explore_obsidian = true
  else
    vim.g.explore_obsidian = false
  end
end

--- Create or open a markdown note for the word under the cursor (architecture log).
function M.note_for_cursor()
  local vault = vault_path()
  if not vault or vim.fn.isdirectory(vault) == 0 then
    vim.notify("Set OBSIDIAN_VAULT or vim.g.obsidian_vault to a folder path", vim.log.levels.WARN)
    return
  end

  local word = vim.fn.expand("<cword>")
  if word == "" then
    vim.notify("No symbol under cursor", vim.log.levels.WARN)
    return
  end

  local safe = word:gsub("[^%w_%-]", "_")
  local notes_dir = vault .. "/notes"
  vim.fn.mkdir(notes_dir, "p")
  local note_path = notes_dir .. "/" .. safe .. ".md"

  if vim.fn.filereadable(note_path) == 0 then
    local rel = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.")
    local lines = {
      "# " .. word,
      "",
      "Source: `" .. (rel ~= "" and rel or "unknown") .. "`",
      "",
      "## Role",
      "",
      "## Calls / called by",
      "- Incoming:",
      "- Outgoing:",
      "",
      "## Class diagram (Mermaid)",
      "```mermaid",
      "classDiagram",
      "    class " .. word,
      "```",
      "",
    }
    vim.fn.writefile(lines, note_path)
  end

  vim.cmd("edit " .. vim.fn.fnameescape(note_path))
end

return M
