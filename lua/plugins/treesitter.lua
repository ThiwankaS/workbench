-- nvim-treesitter v2+ (rewrite): `ensure_installed` in opts is only used by :TSInstallAll; parsers are
-- installed with `require("nvim-treesitter").install { ... }`. The plugin also recommends `lazy = false`
-- and an explicit `install_dir` (must match `vim.opt.rtp` in options.lua).
local extra = {
  "asm",
  "bash",
  "c",
  "cmake",
  "cpp",
  "make",
  "markdown",
  "markdown_inline",
  "javascript",
  "typescript",
  "python",
  "json",
  "yaml",
}

local install_dir = vim.fs.normalize(vim.fn.stdpath("data") .. "/site")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        install_dir = install_dir,
      })
      -- Ensure C/C++ parsers exist after clearing cache (no-op when already present).
      vim.defer_fn(function()
        local ok, err = pcall(function()
          require("nvim-treesitter").install({ "c", "cpp" }):wait(300000)
        end)
        if not ok then
          vim.notify(
            "nvim-treesitter could not install c/cpp parsers: "
              .. tostring(err)
              .. "\nNeed: curl, tar, tree-sitter-cli 0.26+, and a C compiler (see nvim-treesitter README).",
            vim.log.levels.WARN
          )
        end
      end, 100)
    end,
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, extra)
      table.sort(opts.ensure_installed)
      opts.ensure_installed = vim.fn.uniq(opts.ensure_installed)
      return opts
    end,
  },
}
