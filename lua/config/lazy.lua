-- Path where lazy.nvim itself is installed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap lazy.nvim only if it is missing.
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

-- Ensure lazy.nvim is on runtime path before plugin setup.
vim.opt.rtp:prepend(lazypath)

-- Plugin manager setup.
require("lazy").setup({
  -- Import modular plugin specs from lua/plugins/*.lua
  spec = { { import = "plugins" } },
  -- Keep startup quiet when plugin files change.
  change_detection = { notify = false },
  -- Disable background update checks to keep setup stable/frozen.
  checker = { enabled = false },
  -- Disable luarocks integration (avoid extra moving parts).
  rocks = { enabled = false },
  -- Respect pinned commits in lazy-lock.json for reproducible setup.
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
})
