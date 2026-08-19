--- CoreForge Workbench — Neovim 0.12 + vim.pack + NvUI
--- Load order matters; see comments below and workbench.html.
vim.loader.enable()

local config = require("config")

-- ── 1. Editor identity ───────────────────────────────────────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"
vim.g.obsidian_vault = config.obsidian_vault

-- ── 2. Options + diagnostics (before plugins) ────────────────────────────────
require("core.options")
require("core.ftdetect")
require("core.font")

-- markdown-preview.nvim reads vim.g.mkdp_* when plugin/mkdp.vim loads (step 4)
require("setup.markdown_preview").configure()

-- ── 3. Plugin lifecycle hooks ──────────────────────────────────────────────────
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      pcall(vim.cmd.TSUpdate)
    end

    if name == "base46" and kind == "update" then
      require("base46").load_all_highlights()
      for _, file in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
        dofile(vim.g.base46_cache .. file)
      end
    end

    if name == "markdown-preview.nvim" and (kind == "add" or kind == "update") then
      require("setup.markdown_preview").install()
    end
  end,
})

-- ── 4. Plugins (vim.pack) ─────────────────────────────────────────────────────
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/NvChad/base46",
  "https://github.com/NvChad/ui",
  "https://github.com/NvChad/volt",
  "https://github.com/nvim-telescope/telescope.nvim",
  { src = "https://github.com/nvim-tree/nvim-tree.lua", name = "nvim-tree" },
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/stevearc/aerial.nvim",
  "https://github.com/MeanderingProgrammer/markdown.nvim",
  "https://github.com/epwalsh/obsidian.nvim",
  "https://github.com/iamcco/markdown-preview.nvim",
}, { confirm = false })

-- ── 5. Plugin setup (UI first, keymaps last) ─────────────────────────────────
require("setup.nvui").setup()
require("setup.clock").setup()
require("setup.treesitter").setup()
require("setup.tree").setup()
require("setup.telescope").setup()
require("setup.explore").setup()
require("setup.lsp").setup()
require("setup.autopairs").setup()
require("setup.cmp").setup()
require("setup.gitsigns").setup()
require("setup.markdown_preview").register_commands()
require("core.keymaps") -- after plugins so user maps are not overridden
