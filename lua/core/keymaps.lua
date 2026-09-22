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

--- Move current line (`visual = false`) or the visual selection (`visual = true`).
--- Visual maps must pass `visual` explicitly: Lua callbacks can already have left
--- Visual, so `nvim_get_mode()` is not trustworthy here.
local function move_lines(delta, visual)
  if blocked() or vim.bo.readonly or not vim.bo.modifiable then
    return
  end

  if visual then
    -- Leave Visual so '< / '> match this selection (marks update on exit).
    api.nvim_feedkeys(api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  end

  local from, to
  if visual then
    from, to = vim.fn.line("'<"), vim.fn.line("'>")
    if from > to then
      from, to = to, from
    end
  else
    from = api.nvim_win_get_cursor(0)[1]
    to = from
  end

  local shift = delta * vim.v.count1
  local last = api.nvim_buf_line_count(0)
  if shift > 0 and to + shift > last then
    return
  end
  if shift < 0 and from + shift < 1 then
    return
  end

  -- :move {addr} puts the range just below {addr} (0 = top of buffer).
  local dest = shift > 0 and (to + shift) or (from + shift - 1)
  if not pcall(vim.cmd, ("silent %d,%dmove %d"):format(from, to, dest)) then
    return
  end

  local new_from, new_to = from + shift, to + shift
  pcall(vim.cmd, ("silent %d,%dnormal! =="):format(new_from, new_to))

  if visual then
    vim.cmd(("normal! %dGV%dG"):format(new_from, new_to))
  else
    local col = api.nvim_win_get_cursor(0)[2]
    api.nvim_win_set_cursor(0, { new_from, col })
  end
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
  if vim.bo.filetype == "typst" then
    require("setup.typst_preview").toggle()
    return
  end
  require("setup.markdown_preview").toggle()
end), extend("Preview"))

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

-- Ctrl+Alt so tmux can keep Alt+hjkl for panes and Left Alt+Shift can
-- keep toggling keyboard layout. <C-M-j> is the same chord as <C-A-j>.
local function map_move(keys, delta, visual, desc)
  local mode = visual and "x" or "n"
  for _, lhs in ipairs(keys) do
    map(mode, lhs, function()
      move_lines(delta, visual)
    end, extend(desc))
  end
end
map_move({ "<C-A-j>", "<C-M-j>" }, 1, false, "Move line down")
map_move({ "<C-A-k>", "<C-M-k>" }, -1, false, "Move line up")
map_move({ "<C-A-j>", "<C-M-j>" }, 1, true, "Move selection down")
map_move({ "<C-A-k>", "<C-M-k>" }, -1, true, "Move selection up")

map("n", "<Esc>", "<cmd>nohlsearch<CR>", extend("Clear search highlight"))

-- ── Spell (English; built-in + Harper on prose — see lua/core/spell.lua) ───────

local function jump_spell(forward)
  local before = api.nvim_win_get_cursor(0)
  vim.cmd("normal! " .. (forward and "]s" or "[s"))
  local after = api.nvim_win_get_cursor(0)
  if before[1] == after[1] and before[2] == after[2] then
    vim.notify("No misspellings", vim.log.levels.INFO)
  end
end

map("n", "<leader>zt", guard(function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
  vim.notify("Spell " .. (vim.opt_local.spell:get() and "on" or "off"))
end), extend("Toggle spell"))
map("n", "<leader>zj", guard(function()
  jump_spell(true)
end), extend("Next misspelling"))
map("n", "<leader>zk", guard(function()
  jump_spell(false)
end), extend("Prev misspelling"))
map("n", "<leader>zs", telescope("spell_suggest"), extend("Spelling suggestions"))
map("n", "<leader>za", guard(function()
  vim.cmd("normal! zg")
end), extend("Add word to dictionary"))

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

-- GUI font zoom (terminal Neovim: change terminal font instead)
if vim.fn.has("gui_running") == 1 then
  local font = require("core.font")
  map({ "n", "i" }, "<C-=>", function()
    font.zoom(1)
  end, extend("Increase font size"))
  map({ "n", "i" }, "<C-->", function()
    font.zoom(-1)
  end, extend("Decrease font size"))
  map({ "n", "i" }, "<C-0>", function()
    font.reset()
  end, extend("Reset font size"))
end
