local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.smartindent = true
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.ttimeoutlen = 50 -- Alt/Meta chords in terminal (Ghostty: enable option-as-meta)
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.hlsearch = true
opt.incsearch = true
opt.showmode = false
opt.laststatus = 3
opt.switchbuf = "usetab,uselast" -- gb jumps to the alternate buffer

-- Diagnostic message text (not just E/W signs in the gutter).
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    source = "if_many",
    spacing = 2,
  },
  signs = true,
  underline = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
    focusable = true,
  },
})

local undodir = vim.fn.stdpath("config") .. "/undodir"
opt.undodir = undodir
vim.fn.mkdir(undodir, "p")
