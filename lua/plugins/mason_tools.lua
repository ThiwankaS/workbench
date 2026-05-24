return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "clangd",
        "clang-format",
        "lua-language-server",
        "typescript-language-server",
        "pyright",
        "bash-language-server",
        "marksman",
        "stylua",
        -- codelldb: installed via mason-nvim-dap (`lua/plugins/dap.lua`)
      },
    },
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
    end,
  },
}
