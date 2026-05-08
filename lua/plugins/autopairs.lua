-- NvChad previously pulled this in via `nvim-cmp`; we use blink.cmp instead, so autopairs must load on its own.
-- Handles `[`/`]`, `(`/`)`, quotes, etc. (blink’s `auto_brackets` only adjusts parens after LSP *accept*, not manual typing.)
return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      map_bs = true,
      disable_filetype = { "TelescopePrompt", "spectre_panel", "vim" },
      fast_wrap = {},
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
    end,
  },
}
