return {
  {
    "mistweaverco/snap.nvim",
    version = "v1.5.0",
    cmd = { "Snap", "SnapInstall" },
    event = "VeryLazy",
    opts = function()
      return require("config.snap").opts()
    end,
    config = function(_, opts)
      local snap_cfg = require("config.snap")
      require("snap").setup(opts)
      snap_cfg.patch_highlights()

      vim.api.nvim_create_user_command("SnapInstall", function()
        if snap_cfg.backend_incomplete() then
          vim.notify(
            "snap.nvim: downloading backend (~127 MB). Or run: " .. snap_cfg.install_script(),
            vim.log.levels.INFO,
            { title = "snap.nvim" }
          )
        end
        require("snap").install_backend()
      end, { desc = "Download snap.nvim backend (~127 MB, one-time)" })

      vim.schedule(function()
        require("snap.backend").ensure_installed(function()
          snap_cfg.notify_backend_missing(vim.log.levels.WARN)
        end)
      end)
    end,
    keys = {
      {
        "<leader>ss",
        "<cmd>Snap<CR>",
        mode = { "n", "v" },
        desc = "Code snapshot (Snap)",
      },
      {
        "<leader>sS",
        "<cmd>Snap html<CR>",
        mode = { "n", "v" },
        desc = "Code snapshot as HTML",
      },
    },
  },
}
