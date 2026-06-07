--- User keymaps (extends nvchad.mappings). Re-loaded on LazyDone to win over plugin maps.
---
--- Notable bindings:
---   Tab / S-Tab (i)     indent / unindent (blink.cmp fallback when no menu)
---   A-j / A-k           move line or selection
---   leader md / mu      move line fallback (no Meta in terminal)
---   H / L               previous / next buffer
---   leader cf           format via Conform (+ LSP fallback)
---   leader gq           format via LSP only
---   leader t- / t\      terminal horizontal / vertical split
---   leader df, [d, ]d   diagnostics float / prev / next
require("nvchad.mappings")

local map = vim.keymap.set
local map_opts = { noremap = true, silent = true }

-- Insert Tab for blink.cmp "fallback" preset (desc must not start with "blink.cmp:").
local function insert_tabstop()
  local col = vim.fn.col(".") - 1
  local sw = vim.bo.softtabstop
  if sw == 0 then
    sw = vim.bo.shiftwidth
  end
  local width = sw - (col % sw)
  if width == 0 then
    width = sw
  end
  if vim.bo.expandtab then
    return string.rep(" ", width)
  end
  return "\t"
end

map("i", "<Tab>", function()
  return insert_tabstop()
end, vim.tbl_extend("force", { expr = true, desc = "Insert tab / soft indent" }, map_opts))

map("i", "<S-Tab>", function()
  return vim.api.nvim_replace_termcodes("<C-d>", true, true, true)
end, vim.tbl_extend("force", { expr = true, desc = "Unindent in insert mode" }, map_opts))

local function move_line(delta)
  return function()
    for _ = 1, vim.v.count1 do
      if delta > 0 then
        vim.cmd("move .+1")
      else
        vim.cmd("move .-2")
      end
    end
    vim.cmd("normal! ==")
  end
end

local function move_visual(delta)
  return function()
    if delta > 0 then
      vim.cmd("move '>+1")
    else
      vim.cmd("move '<-2")
    end
    vim.cmd("normal! gv")
    vim.cmd("normal! ==")
  end
end

local move_down = move_line(1)
local move_up = move_line(-1)
local move_sel_down = move_visual(1)
local move_sel_up = move_visual(-1)

for _, key in ipairs({ "<A-j>", "<M-j>" }) do
  map("n", key, move_down, vim.tbl_extend("force", { desc = "Move line down" }, map_opts))
  map("v", key, move_sel_down, vim.tbl_extend("force", { desc = "Move selection down" }, map_opts))
end

for _, key in ipairs({ "<A-k>", "<M-k>" }) do
  map("n", key, move_up, vim.tbl_extend("force", { desc = "Move line up" }, map_opts))
  map("v", key, move_sel_up, vim.tbl_extend("force", { desc = "Move selection up" }, map_opts))
end

map("n", "<leader>md", move_down, { desc = "Move line down" })
map("n", "<leader>mu", move_up, { desc = "Move line up" })
map("v", "<leader>md", move_sel_down, { desc = "Move selection down" })
map("v", "<leader>mu", move_sel_up, { desc = "Move selection up" })

map("n", "U", "<C-r>", { desc = "Redo" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close current buffer" })
map("n", "L", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "H", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<C-a>", "ggVG", { desc = "Select all in buffer" })

map("n", "<leader>cd", "<cmd>lcd %:p:h<cr><cmd>pwd<cr>", { desc = "Cd to buffer directory" })

map("i", "<C-u>", "<Esc>gUiwgi", { desc = "Uppercase current word" })
map("i", "<C-l>", "<Esc>guiwgi", { desc = "Lowercase current word" })

map("v", "<", "<gv", { desc = "Indent left and re-select" })
map("v", ">", ">gv", { desc = "Indent right and re-select" })

map("n", "<leader><leader>", ":", { desc = "Command line" })

map("n", "<leader>df", vim.diagnostic.open_float, { desc = "Diagnostic messages (float at cursor)" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

map("n", "<leader>t-", "<cmd>split | terminal<CR>", { desc = "Terminal horizontal split (below)" })
map("n", "<leader>t\\", "<cmd>vsplit | terminal<CR>", { desc = "Terminal vertical split (right)" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal insert" })

map({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer (Conform)" })

map({ "n", "v", "x" }, "<leader>gq", "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", {
  desc = "Format via LSP",
})
