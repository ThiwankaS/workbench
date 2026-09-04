--- nvim-cmp: LSP + LuaSnip + path + buffer completion. Keys here only — no Tab hijacking.
local M = {}

function M.setup()
  require("setup.snippets").setup()

  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")

  vim.opt.completeopt = "menu,menuone,noselect"

  local confirm = cmp.mapping.confirm({ select = true })

  local options = vim.tbl_deep_extend("force", require("nvchad.cmp"), {
    preselect = cmp.PreselectMode.Item,
    confirmation = {
      default_behavior = cmp.ConfirmBehavior.Replace,
    },
    completion = {
      autocomplete = {
        cmp.TriggerEvent.TextChanged,
        cmp.TriggerEvent.InsertEnter,
      },
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"] = cmp.mapping(confirm, { "i", "s" }),
      ["<C-y>"] = cmp.mapping(confirm, { "i", "s" }),
      ["<C-n>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.jumpable(1) then
          luasnip.jump(1)
        else
          cmp.complete()
        end
      end),
      ["<C-p>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end),
    }),
    sources = {
      { name = "nvim_lsp", priority = 1000 },
      { name = "luasnip", priority = 750 },
      { name = "path", priority = 500 },
      { name = "buffer", keyword_length = 3, priority = -1 },
    },
  })

  cmp.setup(options)
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
