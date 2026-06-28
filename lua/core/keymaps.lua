local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- File tree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", vim.tbl_extend("force", { desc = "Toggle file tree" }, opts))
map("n", "<leader>E", "<cmd>NvimTreeFindFile<CR>", vim.tbl_extend("force", { desc = "Reveal file in tree" }, opts))

-- Telescope
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

-- Buffers / windows
map("n", "<leader>w", "<cmd>w<CR>", vim.tbl_extend("force", { desc = "Save" }, opts))
map("n", "<leader>q", "<cmd>q<CR>", vim.tbl_extend("force", { desc = "Quit" }, opts))
map("n", "<leader>x", "<cmd>bdelete<CR>", vim.tbl_extend("force", { desc = "Close buffer" }, opts))
map("n", "<Esc>", "<cmd>nohlsearch<CR>", vim.tbl_extend("force", { desc = "Clear search" }, opts))
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Insert: word case
map("i", "<C-u>", "<Esc>gUiwgi", vim.tbl_extend("force", { desc = "Uppercase word" }, opts))
map("i", "<C-l>", "<Esc>guiwgi", vim.tbl_extend("force", { desc = "Lowercase word" }, opts))

-- LSP (buffer-local on attach)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
  callback = function(args)
    local buf = args.buf
    local function bmap(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true })
    end
    bmap("n", "gd", vim.lsp.buf.definition, "Definition")
    bmap("n", "gr", vim.lsp.buf.references, "References")
    bmap("n", "K", vim.lsp.buf.hover, "Hover")
    bmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
    bmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    bmap("n", "<leader>cf", function()
      vim.lsp.buf.format({ async = true })
    end, "Format")
    bmap("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
    bmap("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
    bmap("n", "<leader>d", vim.diagnostic.open_float, "Diagnostic float")
  end,
})
