--- Lazy.nvim plugin specifications (single module).
local M = {}

local parsers = { "c", "cpp", "javascript", "python", "asm", "lua", "vim", "vimdoc", "bash", "json" }

M = {
  -- Colorscheme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
        italic = { strings = true, comments = true },
        bold = true,
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})
      vim.schedule(function()
        pcall(function()
          require("nvim-treesitter").install(parsers)
        end)
      end)
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_syntax", { clear = true }),
        pattern = { "c", "cpp", "javascript", "python", "asm", "nasm", "gas" },
        callback = function(args)
          vim.bo[args.buf].syntax = ""
        end,
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = "  ",
          sorting_strategy = "ascending",
          layout_config = { horizontal = { prompt_position = "top" } },
        },
      })
    end,
  },

  -- Mason + LSP
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup()
      local packages = { "clangd", "typescript-language-server", "pyright", "asm-lsp" }
      vim.schedule(function()
        local ok, registry = pcall(require, "mason-registry")
        if not ok then
          return
        end
        registry.refresh(function()
          for _, name in ipairs(packages) do
            if registry.has_package(name) and not registry.get_package(name):is_installed() then
              registry.get_package(name):install()
            end
          end
        end)
      end)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      local function setup(server, opts)
        opts = vim.tbl_deep_extend("force", { capabilities = capabilities }, opts or {})
        if vim.lsp.config then
          vim.lsp.config(server, opts)
          vim.lsp.enable(server)
        else
          require("lspconfig")[server].setup(opts)
        end
      end

      setup("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
        },
        filetypes = { "c", "cpp" },
        root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", "CMakeLists.txt", ".git" },
      })

      setup("ts_ls")
      setup("pyright", {
        settings = {
          python = {
            analysis = { typeCheckingMode = "basic" },
          },
        },
      })
      setup("asm_lsp")
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = { expand = function(_) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer", keyword_length = 3 },
        },
      })
    end,
  },
}

return M
