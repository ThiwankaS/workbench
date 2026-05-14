require("nvchad.mappings")

local map = vim.keymap.set

-- Default `U` is “undo all changes on this line” — surprising vs `u` (step undo). Most people expect
-- Shift+U / `U` to redo (same role as `<C-r>`). Leave Visual `U` unchanged (uppercase selection).
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

-- Diagnostics (see `:help diagnostic`). `<leader>ds` is NvChad → loclist; `<leader>dl` is DAP.
map("n", "<leader>df", vim.diagnostic.open_float, { desc = "Diagnostic messages (float at cursor)" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

map("n", "<leader>t-", "<cmd>split | terminal<CR>", { desc = "Terminal horizontal split (below)" })
map("n", "<leader>t\\", "<cmd>vsplit | terminal<CR>", { desc = "Terminal vertical split (right)" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal insert" })

map(
  { "n", "v" },
  "<leader>cf",
  function()
    require("conform").format({ async = true, lsp_fallback = true })
  end,
  { desc = "Format buffer (Conform)" }
)

map({ "n", "v", "x" }, "<leader>gq", "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", {
  desc = "Format via LSP",
})
