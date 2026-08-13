--- CoreForge Workbench — Neovim 0.12 + vim.pack + NvUI
--- https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

-- markdown-preview.nvim reads these when plugin/mkdp.vim loads (before pack.add below)
require("setup.markdown_preview").setup()

-- Optional Obsidian vault for architecture notes (export OBSIDIAN_VAULT=... or set path here):
vim.g.obsidian_vault = vim.fn.expand("~/Documents/Obsidian/Main")

require("core.options")
require("core.font")

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

require("setup.nvui")
require("setup.clock").setup()
require("setup.treesitter")
require("setup.tree")
require("setup.telescope")
require("setup.explore").setup()
require("setup.lsp")
require("setup.autopairs")
require("setup.cmp")
require("setup.gitsigns")
require("core.keymaps") -- last so plugin defaults do not override user maps
