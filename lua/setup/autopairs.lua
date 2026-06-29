local npairs = require("nvim-autopairs")

npairs.setup({
  check_ts = true,
  map_cr = false, -- let nvim-cmp own <CR>; pairs hook via confirm_done
  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
    c = { "string", "comment" },
    cpp = { "string", "comment" },
    python = { "string", "comment" },
  },
  disable_filetype = { "TelescopePrompt", "spectre_panel", "NvimTree" },
  -- Alt+e: jump past a closing pair when inside brackets/quotes
  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", '"', "'", "`" },
    keys = "qwertyuiopzxcvbnmasdfghjkl",
  },
})

return npairs
