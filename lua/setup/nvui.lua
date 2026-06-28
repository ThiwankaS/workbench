local cache = vim.g.base46_cache
vim.fn.mkdir(cache, "p")

if vim.fn.empty(vim.fn.glob(cache .. "/*")) == 1 then
  require("base46").load_all_highlights()
end

for _, file in ipairs(vim.fn.readdir(cache)) do
  dofile(cache .. file)
end

-- Skip NvChad one-time upstream notification popup
vim.fn.mkdir(vim.fn.stdpath("data") .. "/nvnotify1", "p")
require("nvchad")
