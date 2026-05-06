return function(opts)
  opts = opts or {}

  local cmp = require("cmp")

  -- Keep global NvChad cmp behavior untouched; only tune C/C++ source priority.
  cmp.setup.filetype({ "c", "cpp" }, {
    completion = {
      keyword_length = 1,
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp", priority = 1000 },
      { name = "buffer", priority = 500, keyword_length = 2 },
      { name = "async_path", priority = 300 },
      { name = "luasnip", priority = 200, keyword_length = 3 },
    }),
  })

  return opts
end
