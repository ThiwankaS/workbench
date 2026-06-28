-- Keymaps tuned for a 65% keyboard.
-- Leader = Space. Global maps skip NvimTree / Telescope (see core/maputil.lua).

local map = vim.keymap.set
local guard = require("core.maputil").guard
local guard_cmd = require("core.maputil").guard_cmd

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

-- Themes (normal buffers only)
map("n", "<leader>th", guard(function()
  require("nvchad.themes").open()
end), extend("Theme picker"))
map("n", "<leader>tt", guard(function()
  require("base46").toggle_theme()
end), extend("Toggle theme pair"))

-- File tree (toggle/reveal always work, including when tree is focused)
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", extend("Toggle file tree"))
map("n", "<leader>j", "<cmd>NvimTreeFindFile<CR>", extend("Reveal file in tree"))

-- Telescope
map("n", "<leader>f", guard(function()
  require("telescope.builtin").find_files()
end), extend("Find files"))
map("n", "<leader>g", guard(function()
  require("telescope.builtin").live_grep()
end), extend("Live grep"))
map("n", "<leader>p", guard(function()
  require("telescope.builtin").buffers()
end), extend("Pick buffer"))
map("n", "<leader>o", guard(function()
  require("telescope.builtin").oldfiles()
end), extend("Recent files"))

-- Buffers
map("n", "gb", guard(toggle_buffer), extend("Toggle last two buffers"))
map("n", "<leader>h", guard(function()
  tabufline().prev()
end), extend("Previous buffer"))
map("n", "<leader>l", guard(function()
  tabufline().next()
end), extend("Next buffer"))

-- Save / quit / close
map("n", "<leader>w", "<cmd>w<CR>", extend("Save"))
map("i", "<C-s>", "<Esc>:w<CR>a", extend("Save"))
map("n", "<C-s>", "<cmd>w<CR>", extend("Save"))
map("n", "<leader>q", guard_cmd("q"), extend("Quit"))
map("n", "<leader>x", guard(function()
  tabufline().close_buffer()
end), extend("Close buffer"))

-- Windows — Ctrl/Alt+hjkl only (never arrow keys; plugins use those)
local win = { h = "<C-w>h", j = "<C-w>j", k = "<C-w>k", l = "<C-w>l" }
for key, cmd in pairs(win) do
  map("n", "<C-" .. key .. ">", cmd, extend("Window " .. key))
  map("n", "<A-" .. key .. ">", cmd, extend("Window " .. key))
end

map("n", "<Esc>", "<cmd>nohlsearch<CR>", extend("Clear search highlight"))

-- Insert: word case (only when cmp menu is closed — see cmp.lua for Ctrl+n/p)
map("i", "<C-u>", "<Esc>gUiwgi", extend("Uppercase word"))
map("i", "<C-l>", "<Esc>guiwgi", extend("Lowercase word"))

-- LSP (code buffers only; never NvimTree / Telescope)
local lsp_ft_skip = {
  NvimTree = true,
  TelescopePrompt = true,
  TelescopeResults = true,
  help = true,
  lazy = true,
  mason = true,
}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
  callback = function(args)
    if lsp_ft_skip[vim.bo[args.buf].filetype] then
      return
    end

    local buf = args.buf
    local function bmap(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true, noremap = true })
    end

    bmap("n", "gd", vim.lsp.buf.definition, "Definition")
    bmap("n", "gr", vim.lsp.buf.references, "References")
    bmap("n", "<leader>k", vim.lsp.buf.hover, "Hover")
    bmap("n", "<leader>n", vim.lsp.buf.rename, "Rename")
    bmap({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, "Code action")
    bmap("n", "<leader>m", function()
      vim.lsp.buf.format({ async = true })
    end, "Format")
    bmap("n", "<leader>dh", vim.diagnostic.goto_prev, "Prev diagnostic")
    bmap("n", "<leader>dl", vim.diagnostic.goto_next, "Next diagnostic")
    bmap("n", "<leader>df", vim.diagnostic.open_float, "Diagnostic float")
  end,
})
