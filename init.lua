-- Enable Lua module bytecode cache for faster startup.
vim.loader.enable()

-- Disable language providers you do not use (faster startup, fewer warnings).
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Include user site runtime path (required by some parser/runtime resources).
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/site")

-- Load core config modules in deterministic order.
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
