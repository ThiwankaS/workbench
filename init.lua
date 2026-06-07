vim.loader.enable()

-- Legacy Treesitter compat (Telescope preview, etc.).
require("config.ts_compat")

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy_cfg = require("configs.lazy")

require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_cfg)

dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("options")
require("autocmds")

local function load_user_maps()
  package.loaded["mappings"] = nil
  require("mappings")
end

load_user_maps()

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("user_config", { clear = false }),
  pattern = "LazyDone",
  once = true,
  callback = load_user_maps,
})
