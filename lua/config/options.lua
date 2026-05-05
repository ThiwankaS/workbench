-- Global leader key for all custom shortcuts.
vim.g.mapleader = " "
-- Local leader key used by some plugins/filetype maps.
vim.g.maplocalleader = " "

-- Shorthand for Neovim option API.
local opt = vim.opt

-- Show absolute line number on current line.
opt.number = true
-- Show relative line numbers for fast motions.
opt.relativenumber = true
-- Highlight the current cursor line.
opt.cursorline = true
-- Enable mouse support in all modes.
opt.mouse = "a"
-- Hide default mode text because statusline already shows it.
opt.showmode = false
-- Show partially typed command at bottom.
opt.showcmd = true
-- Use system clipboard (copy/paste with OS apps).
opt.clipboard = "unnamedplus"
-- Keep indentation in wrapped lines.
opt.breakindent = true
-- Disable swap files.
opt.swapfile = false
-- Disable backup files.
opt.backup = false
-- Keep search matches highlighted.
opt.hlsearch = true
-- Incremental search while typing.
opt.incsearch = true
-- Enable persistent undo.
opt.undofile = true
-- Directory where undo history is stored.
local undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
-- Tell Neovim where to store undo files.
opt.undodir = undodir
-- Create undo directory automatically if missing.
vim.fn.mkdir(undodir, "p")
-- Case-insensitive search by default.
opt.ignorecase = true
-- Become case-sensitive if uppercase letters are used in search.
opt.smartcase = true
-- Always show sign column with fixed width.
opt.signcolumn = "yes:1"
-- Faster CursorHold and diagnostics refresh.
opt.updatetime = 200
-- Leader key timeout for mapped sequences.
opt.timeoutlen = 300
-- Vertical splits open on the right.
opt.splitright = true
-- Horizontal splits open below.
opt.splitbelow = true
-- Enable true color support.
opt.termguicolors = true
-- Keep 8 lines visible around cursor while scrolling.
opt.scrolloff = 8
-- Keep side context for horizontal scrolling.
opt.sidescrolloff = 8
-- Convert tabs to spaces.
opt.expandtab = true
-- Display width of a tab character.
opt.tabstop = 4
-- Edit-time tab width behavior.
opt.softtabstop = 4
-- Indent width for >> << and autoindent.
opt.shiftwidth = 4
-- Copy indentation from current line.
opt.autoindent = true
-- Smarter indentation for many programming languages.
opt.smartindent = true
-- Use shiftwidth at start of line when pressing Tab.
opt.smarttab = true
-- Show invisible characters for whitespace awareness.
opt.list = true
-- Visual markers for tab, trailing spaces, and non-breaking spaces.
opt.listchars:append({ tab = ">>", trail = ".", nbsp = "_" })
