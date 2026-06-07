--- CoreForge Workbench — Neovim entry (NvChad v2.5 + lazy.nvim).
--- Layout:
---   init.lua          bootstrap, lazy, user commands
---   lua/chadrc.lua    NvChad UI + base46 theme hook
---   lua/options.lua   editor options
---   lua/mappings.lua  keymaps (re-loaded after LazyDone)
---   lua/autocmds.lua  autocmds
---   lua/config/       user modules (theme, format, snap, …)
---   lua/configs/      plugin option tables (lazy, lsp, conform)
---   lua/plugins/      lazy.nvim plugin specs
vim.loader.enable()

require("config.ts_compat")

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim ---------------------------------------------------------
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

require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  { import = "plugins" },
}, require("configs.lazy"))

-- Early base46 cache (full reload happens on LazyDone)
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
  callback = function()
    load_user_maps()
    vim.schedule(require("config.theme").reload)
  end,
})

vim.api.nvim_create_user_command("WorkbenchThemeReload", function()
  require("config.theme").reload()
end, { desc = "Rebuild base46 + Treesitter syntax colors (after editing lua/config/theme.lua)" })
