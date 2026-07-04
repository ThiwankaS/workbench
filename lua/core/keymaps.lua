-- Keymaps tuned for a 65% keyboard.
-- Leader = Space. Global maps skip NvimTree / Telescope (see core/maputil.lua).

local api = vim.api
local map = vim.keymap.set
local guard = require("core.maputil").guard
local guard_cmd = require("core.maputil").guard_cmd
local blocked = require("core.maputil").ft_blocked

local opts = { noremap = true, silent = true }
local extend = function(desc)
  return vim.tbl_extend("force", { desc = desc }, opts)
end

local tabufline = function()
  return require("nvchad.tabufline")
end

local function prev_buffer()
  local ok, tabuf = pcall(tabufline)
  if ok and vim.t.bufs and #vim.t.bufs > 1 then
    tabuf.prev()
    return
  end
  vim.cmd("bprevious")
end

local function next_buffer()
  local ok, tabuf = pcall(tabufline)
  if ok and vim.t.bufs and #vim.t.bufs > 1 then
    tabuf.next()
    return
  end
  vim.cmd("bnext")
end

local function toggle_buffer()
  local alt = vim.fn.bufnr("#")
  if alt ~= -1 and api.nvim_buf_is_valid(alt) and vim.bo[alt].buflisted then
    vim.cmd("buffer #")
    return
  end
  next_buffer()
end

local function move_lines(delta)
  if blocked() then
    return
  end
  local mode = api.nvim_get_mode().mode
  if mode == "v" or mode == "V" or mode == "\22" then
    vim.cmd("'<,'>move " .. (delta > 0 and "'>+1" or "'<-2"))
    vim.cmd("normal! gv=")
    return
  end
  local row = api.nvim_win_get_cursor(0)[1]
  local last = api.nvim_buf_line_count(0)
  if (delta > 0 and row >= last) or (delta < 0 and row <= 1) then
    return
  end
  vim.cmd("move " .. (delta > 0 and ".+1" or ".-2"))
  vim.cmd("normal! ==")
end

-- Themes (normal buffers only)
map("n", "<leader>th", guard(function()
  require("nvchad.themes").open()
end), extend("Theme picker"))
map("n", "<leader>tt", guard(function()
  require("base46").toggle_theme()
end), extend("Toggle theme pair"))

-- File tree (always available)
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
map("n", "<leader>h", guard(prev_buffer), extend("Previous buffer"))
map("n", "<leader>l", guard(next_buffer), extend("Next buffer"))

-- Save / quit / close
map("n", "<leader>w", "<cmd>w<CR>", extend("Save"))
map("i", "<C-s>", "<Esc>:w<CR>a", extend("Save"))
map("n", "<leader>q", guard_cmd("q"), extend("Quit"))
map("n", "<leader>x", guard(function()
  tabufline().close_buffer()
end), extend("Close buffer"))

-- Windows
local win = { h = "<C-w>h", j = "<C-w>j", k = "<C-w>k", l = "<C-w>l" }
for key, cmd in pairs(win) do
  map("n", "<C-" .. key .. ">", cmd, extend("Window " .. key))
end

-- Move lines
map("n", "<A-j>", function()
  move_lines(1)
end, extend("Move line down"))
map("n", "<A-k>", function()
  move_lines(-1)
end, extend("Move line up"))
map("v", "<A-j>", function()
  move_lines(1)
end, extend("Move selection down"))
map("v", "<A-k>", function()
  move_lines(-1)
end, extend("Move selection up"))

map("n", "<Esc>", "<cmd>nohlsearch<CR>", extend("Clear search highlight"))

-- Diagnostics
map("n", "<leader>dd", guard(function()
  vim.diagnostic.open_float(0, { scope = "cursor", focus = true, border = "rounded" })
end), extend("Diagnostic message"))
map("n", "<leader>dk", guard(function()
  vim.diagnostic.goto_prev({ float = true, wrap = true })
end), extend("Prev diagnostic"))
map("n", "<leader>dj", guard(function()
  vim.diagnostic.goto_next({ float = true, wrap = true })
end), extend("Next diagnostic"))

-- Insert: word case (cmp uses Ctrl+n/p — see setup/cmp.lua)
map("i", "<C-u>", "<Esc>gUiwgi", extend("Uppercase word"))
map("i", "<C-l>", "<Esc>guiwgi", extend("Lowercase word"))

-- LSP (code buffers only)
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
    local buf = args.buf
    local ft = vim.bo[buf].filetype

    if vim.lsp.completion and vim.lsp.completion.enable then
      pcall(vim.lsp.completion.enable, false, args.data.client_id, buf)
    end

    if lsp_ft_skip[ft] then
      return
    end

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
  end,
})
