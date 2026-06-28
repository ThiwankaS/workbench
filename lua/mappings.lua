--- User keymaps (extends nvchad.mappings). Re-loaded on LazyDone to win over plugin maps.
---
--- Notable bindings:
---   Tab / S-Tab (i)     blink.cmp: menu → snippet → indent (lua/plugins/blink.lua)
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

local function move_line(delta)
  return function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local n = vim.v.count1
    if delta > 0 then
      local last = vim.api.nvim_buf_line_count(0)
      if row >= last then
        return
      end
      local dest = math.min(row + n, last)
      vim.cmd(string.format("%dm%s", row, dest))
    else
      if row <= 1 then
        return
      end
      local dest = math.max(row - n - 1, -1)
      vim.cmd(string.format("%dm%s", row, dest))
    end
    vim.cmd("normal! ==")
  end
end

local function move_visual(delta)
  return function()
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    if delta > 0 then
      if end_line >= vim.api.nvim_buf_line_count(0) then
        return
      end
      vim.cmd(string.format("%d,%dm%d", start_line, end_line, end_line + 1))
    else
      if start_line <= 1 then
        return
      end
      vim.cmd(string.format("%d,%dm%d", start_line, end_line, start_line - 2))
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

map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle explorer" })
map("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Find file in explorer" })
map("n", "<leader>fm", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer (Conform)" })

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
