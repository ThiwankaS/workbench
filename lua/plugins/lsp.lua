return {
  {
    -- External tool/LSP installer UI.
    "williamboman/mason.nvim",
    config = true,
  },
  {
    -- Bridge between Mason packages and nvim-lsp.
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      -- Language servers to keep installed.
      ensure_installed = { "lua_ls", "clangd", "ts_ls", "pyright", "bashls", "marksman" },
    },
  },
  {
    -- Built-in Neovim LSP client configuration.
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Add cmp completion capabilities to every LSP client.
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Buffer-local LSP mappings set when a server attaches.
      local on_attach = function(_, bufnr)
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gr", vim.lsp.buf.references, "References")
        map("K", vim.lsp.buf.hover, "Hover")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
      end

      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Lua language server tweaks for Neovim config editing.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      -- Enable configured servers.
      vim.lsp.enable({ "lua_ls", "clangd", "ts_ls", "pyright", "bashls", "marksman" })
    end,
  },
  {
    -- Completion engine.
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        -- Snippet expansion backend.
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          -- VS Code-like completion navigation/confirm.
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }),
      })
    end,
  },
}
