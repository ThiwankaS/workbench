-- Keymaps tuned for a 65% keyboard (no arrow cluster, brackets on Fn layer).
-- Leader = Space. Prefer home-row chords over Shift+Tab and [ ] keys.

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local extend = function(desc)
  return vim.tbl_extend("force", { desc = desc }, opts)
end

local tabufline = function()
  return require("nvchad.tabufline")
end

local function toggle_buffer()
  if vim.fn.bufnr("#") == -1 then
    return
  end
  vim.cmd.buffer("#")
end

-- Themes
map("n", "<leader>th", function()
  require("nvchad.themes").open()
end, extend("Theme picker"))
map("n", "<leader>tt", function()
  require("base46").toggle_theme()
end, extend("Toggle theme pair"))

-- File tree (e = explorer, j = jump to file in tree — no Shift+E)
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", extend("Toggle file tree"))
map("n", "<leader>j", "<cmd>NvimTreeFindFile<CR>", extend("Reveal file in tree"))

-- Telescope — single home-row key after leader
map("n", "<leader>f", function()
  require("telescope.builtin").find_files()
end, extend("Find files"))
map("n", "<leader>g", function()
  require("telescope.builtin").live_grep()
end, extend("Live grep"))
map("n", "<leader>p", function()
  require("telescope.builtin").buffers()
end, extend("Pick buffer"))
map("n", "<leader>o", function()
  require("telescope.builtin").oldfiles()
end, extend("Recent files"))

-- Buffers — gb + home-row h/l (Ctrl+h/l = windows, Space+h/l = buffers)
map("n", "gb", toggle_buffer, extend("Toggle last two buffers"))
map("n", "<leader>h", function()
  tabufline().prev()
end, extend("Previous buffer"))
map("n", "<leader>l", function()
  tabufline().next()
end, extend("Next buffer"))

-- Save / quit / close
map("n", "<leader>w", "<cmd>w<CR>", extend("Save"))
map("i", "<C-s>", "<Esc>:w<CR>a", extend("Save"))
map("n", "<C-s>", "<cmd>w<CR>", extend("Save"))
map("n", "<leader>q", "<cmd>q<CR>", extend("Quit"))
map("n", "<leader>x", function()
  tabufline().close_buffer()
end, extend("Close buffer"))

-- Windows — Ctrl+hjkl + Fn-layer arrows
local win = { h = "<C-w>h", j = "<C-w>j", k = "<C-w>k", l = "<C-w>l" }
for key, cmd in pairs(win) do
  map("n", "<C-" .. key .. ">", cmd, opts)
  map("n", "<A-" .. key .. ">", cmd, extend("Window " .. key))
end
map("n", "<Left>", win.h, extend("Window left"))
map("n", "<Down>", win.j, extend("Window down"))
map("n", "<Up>", win.k, extend("Window up"))
map("n", "<Right>", win.l, extend("Window right"))

map("n", "<Esc>", "<cmd>nohlsearch<CR>", extend("Clear search highlight"))

-- Insert: word case (Ctrl+u/l — no shifted keys)
map("i", "<C-u>", "<Esc>gUiwgi", extend("Uppercase word"))
map("i", "<C-l>", "<Esc>guiwgi", extend("Lowercase word"))

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

    -- No Shift+K on 65%
    bmap("n", "<leader>k", vim.lsp.buf.hover, "Hover")
    bmap("n", "<leader>n", vim.lsp.buf.rename, "Rename")
    bmap({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, "Code action")
    bmap("n", "<leader>m", function()
      vim.lsp.buf.format({ async = true })
    end, "Format")

    -- No [d / ]d — use leader+hj (home row)
    bmap("n", "<leader>dh", vim.diagnostic.goto_prev, "Prev diagnostic")
    bmap("n", "<leader>dl", vim.diagnostic.goto_next, "Next diagnostic")
    bmap("n", "<leader>df", vim.diagnostic.open_float, "Diagnostic float")
  end,
})
