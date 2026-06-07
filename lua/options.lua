require("nvchad.options")

-- Third-party parsers / tooling live under stdpath('data')/site — keep queries on rtp.
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/site")

local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.cursorline = true
opt.mouse = "a"
opt.breakindent = true
opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.backup = false
opt.hlsearch = true
opt.incsearch = true
opt.termguicolors = true
opt.undofile = true

local undodir = vim.fn.stdpath("config") .. "/undodir"
opt.undodir = undodir
vim.fn.mkdir(undodir, "p")

opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes:1"
opt.updatetime = 200
opt.timeoutlen = 300
-- Faster merge of Esc+key into Meta in some terminals (Alt+j / Alt+k).
opt.ttimeoutlen = 20
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.autoindent = true
opt.smartindent = true
opt.smarttab = true

opt.showmode = false
opt.showcmd = true
opt.list = true
opt.listchars:append({ tab = ">>", trail = ".", nbsp = "_" })
