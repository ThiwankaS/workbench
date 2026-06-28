--- Keymaps — Telescope, LSP, editing essentials.
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Telescope (lazy-loaded on first use)
map("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, vim.tbl_extend("force", { desc = "Find files" }, opts))

map("n", "<leader>fg", function()
  require("telescope.builtin").live_grep()
end, vim.tbl_extend("force", { desc = "Live grep" }, opts))

map("n", "<leader>fb", function()
  require("telescope.builtin").buffers()
end, vim.tbl_extend("force", { desc = "Buffers" }, opts))

map("n", "<leader>fr", function()
  require("telescope.builtin").oldfiles()
end, vim.tbl_extend("force", { desc = "Recent files" }, opts))

map("n", "<leader>fh", function()
  require("telescope.builtin").help_tags()
end, vim.tbl_extend("force", { desc = "Help tags" }, opts))

-- Buffers
map("n", "<leader>q", "<cmd>q<CR>", vim.tbl_extend("force", { desc = "Quit" }, opts))
map("n", "<leader>w", "<cmd>w<CR>", vim.tbl_extend("force", { desc = "Write" }, opts))
map("n", "<leader>x", "<cmd>bdelete<CR>", vim.tbl_extend("force", { desc = "Close buffer" }, opts))
map("n", "<Esc>", "<cmd>nohlsearch<CR>", vim.tbl_extend("force", { desc = "Clear search" }, opts))

-- Windows
map("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", { desc = "Window left" }, opts))
map("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", { desc = "Window down" }, opts))
map("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", { desc = "Window up" }, opts))
map("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", { desc = "Window right" }, opts))

-- Insert: transform word under cursor (leave insert mode briefly, then return)
map("i", "<C-u>", "<Esc>gUiwgi", vim.tbl_extend("force", { desc = "Uppercase current word" }, opts))
map("i", "<C-l>", "<Esc>guiwgi", vim.tbl_extend("force", { desc = "Lowercase current word" }, opts))

-- LSP (buffer-local maps set on attach)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
  callback = function(args)
    local buf = args.buf
    local function bmap(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true })
    end

    bmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
    bmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    bmap("n", "gr", vim.lsp.buf.references, "References")
    bmap("n", "gi", vim.lsp.buf.implementation, "Implementation")
    bmap("n", "K", vim.lsp.buf.hover, "Hover")
    bmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
    bmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    bmap("n", "<leader>cf", function()
      vim.lsp.buf.format({ async = true })
    end, "Format buffer")
    bmap("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
    bmap("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
    bmap("n", "<leader>e", vim.diagnostic.open_float, "Diagnostic float")
  end,
})
