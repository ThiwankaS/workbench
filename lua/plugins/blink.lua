-- Replaces NvChad's nvim-cmp stack (`hrsh7th/nvim-cmp` disabled in `lua/plugins/init.lua`).
-- LuaSnip stays available via explicit dependency + `nvchad.configs.luasnip`.

local function insert_tabstop()
  local col = vim.fn.col(".") - 1
  local sw = vim.bo.softtabstop
  if sw == 0 then
    sw = vim.bo.shiftwidth
  end
  local width = sw - (col % sw)
  if width == 0 then
    width = sw
  end
  if vim.bo.expandtab then
    return string.rep(" ", width)
  end
  return "\t"
end

local function unindent_tabstop()
  return vim.api.nvim_replace_termcodes("<C-d>", true, true, true)
end

return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    lazy = false,
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = { history = true, updateevents = { "TextChanged", "TextChangedI" } },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require("nvchad.configs.luasnip")
        end,
      },
    },
    opts = {
      snippets = { preset = "luasnip" },
      -- Tab order: completion menu → snippet jump → soft indent (no mappings.lua Tab override).
      keymap = {
        preset = "enter",
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", insert_tabstop },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", unindent_tabstop },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 150,
        },
        trigger = {
          prefetch_on_insert = false,
          show_on_keyword = true,
          show_on_trigger_character = true,
        },
        list = {
          selection = {
            -- Required for Enter/accept to work without extra keys first.
            preselect = true,
            auto_insert = false,
          },
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
      },
      -- nvim-lite order: LSP and path before buffer/snippets so semantic items win when present.
      sources = {
        default = { "lsp", "path", "buffer", "snippets" },
        -- For C/C++, drop `buffer` and disable LSP/path → buffer fallbacks (see providers below).
        per_filetype = {
          cpp = { inherit_defaults = false, "lsp", "path", "snippets" },
          c = { inherit_defaults = false, "lsp", "path", "snippets" },
        },
        providers = {
          lsp = {
            timeout_ms = function(ctx)
              local ft = vim.bo[ctx.bufnr].filetype
              return (ft == "cpp" or ft == "c") and 4000 or 2000
            end,
            score_offset = function(ctx)
              local ft = vim.bo[ctx.bufnr].filetype
              return (ft == "cpp" or ft == "c") and 8 or 0
            end,
            fallbacks = function(ctx, _)
              local ft = vim.bo[ctx.bufnr].filetype
              if ft == "cpp" or ft == "c" then
                return {}
              end
              return { "buffer" }
            end,
          },
          path = {
            fallbacks = function(ctx, _)
              local ft = vim.bo[ctx.bufnr].filetype
              if ft == "cpp" or ft == "c" then
                return {}
              end
              return { "buffer" }
            end,
          },
          snippets = {
            score_offset = function(ctx)
              local ft = vim.bo[ctx.bufnr].filetype
              return (ft == "cpp" or ft == "c") and -20 or -1
            end,
          },
        },
      },
      fuzzy = {
        -- Match nvim-lite: prefer native fuzzy binary when available (faster / stable ranking).
        implementation = "prefer_rust_with_warning",
        prebuilt_binaries = { download = true },
      },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default", "sources.per_filetype", "sources.providers" },
  },
}
