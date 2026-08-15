--- Auto-pairs with Treesitter awareness. Alt+e jumps past closing delimiters.
local M = {}

function M.setup()
  require("nvim-autopairs").setup({
    check_ts = true,
    map_cr = false, -- nvim-cmp owns <CR>; pairs hook via confirm_done in cmp.lua
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      c = { "string", "comment" },
      cpp = { "string", "comment" },
      python = { "string", "comment" },
    },
    disable_filetype = { "TelescopePrompt", "spectre_panel", "NvimTree" },
    fast_wrap = {
      map = "<M-e>",
      chars = { "{", "[", "(", '"', "'", "`" },
      keys = "qwertyuiopzxcvbnmasdfghjkl",
    },
  })
end

return M
