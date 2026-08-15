--- All user keymaps. Leader = Space. See lua/core/maputil.lua for plugin-buffer guards.
local api = vim.api
local map = vim.keymap.set
local guard = require("core.maputil").guard
local guard_cmd = require("core.maputil").guard_cmd
local blocked = require("core.maputil").ft_blocked

local opts = { noremap = true, silent = true }
local extend = function(desc)
  return vim.tbl_extend("force", { desc = desc }, opts)
end

-- ── Helpers ────────────────────────────────────────────────────────────────────

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
    vim.cmd("'<,'>move " .. (delta > 0 and "'>+1" or ".-2"))
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

local telescope = function(name)
  return guard(function()
    require("telescope.builtin")[name]()
  end)
end

-- ── Theme ──────────────────────────────────────────────────────────────────────

map("n", "<leader>th", guard(function()
  require("nvchad.themes").open()
end), extend("Theme picker"))
map("n", "<leader>tt", guard(function()
  require("base46").toggle_theme()
end), extend("Toggle theme pair"))

-- ── File tree (always available, including when tree is focused) ───────────────

map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", extend("Toggle file tree"))
map("n", "<leader>j", "<cmd>NvimTreeFindFile<CR>", extend("Reveal file in tree"))

-- ── Telescope ─────────────────────────────────────────────────────────────────

map("n", "<leader>f", telescope("find_files"), extend("Find files"))
map("n", "<leader>g", telescope("live_grep"), extend("Live grep"))
map("n", "<leader>p", telescope("buffers"), extend("Pick buffer"))
map("n", "<leader>o", telescope("oldfiles"), extend("Recent files"))

-- ── Code exploration (LSP + docs) ────────────────────────────────────────────

map("n", "<leader>u", guard(function()
  require("aerial").toggle()
end), extend("Symbol outline"))
map("n", "<leader>ss", telescope("lsp_document_symbols"), extend("Symbols in file"))
map("n", "<leader>sw", telescope("lsp_dynamic_workspace_symbols"), extend("Symbols in project"))
map("n", "<leader>si", telescope("lsp_incoming_calls"), extend("Incoming calls"))
map("n", "<leader>so", telescope("lsp_outgoing_calls"), extend("Outgoing calls"))
map("n", "<leader>sn", guard(function()
  require("setup.explore").note_for_cursor()
end), extend("Architecture note"))
map("n", "<leader>mp", guard(function()
  require("setup.markdown_preview").toggle()
end), extend("Markdown preview"))

-- ── Buffers & windows ─────────────────────────────────────────────────────────

map("n", "gb", guard(toggle_buffer), extend("Toggle last two buffers"))
map("n", "<leader>h", guard(prev_buffer), extend("Previous buffer"))
map("n", "<leader>l", guard(next_buffer), extend("Next buffer"))

local win = { h = "<C-w>h", j = "<C-w>j", k = "<C-w>k", l = "<C-w>l" }
for key, cmd in pairs(win) do
  map("n", "<C-" .. key .. ">", cmd, extend("Window " .. key))
end

-- ── Edit ──────────────────────────────────────────────────────────────────────

map("n", "<leader>w", "<cmd>w<CR>", extend("Save"))
map("i", "<C-s>", "<Esc>:w<CR>a", extend("Save"))
map("n", "<leader>q", guard_cmd("q"), extend("Quit"))
map("n", "<leader>x", guard(function()
  tabufline().close_buffer()
end), extend("Close buffer"))

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

-- ── Diagnostics (uses vim.diagnostic.config from core/options.lua) ────────────

map("n", "<leader>dd", guard(function()
  vim.diagnostic.open_float(0, { scope = "cursor", focus = true })
end), extend("Diagnostic message"))
map("n", "<leader>dk", guard(function()
  vim.diagnostic.goto_prev({ float = true, wrap = true })
end), extend("Prev diagnostic"))
map("n", "<leader>dj", guard(function()
  vim.diagnostic.goto_next({ float = true, wrap = true })
end), extend("Next diagnostic"))

-- ── Insert editing (completion keys live in setup/cmp.lua) ───────────────────

map("i", "<C-u>", "<Esc>gUiwgi", extend("Uppercase word"))
map("i", "<C-l>", "<Esc>guiwgi", extend("Lowercase word"))
