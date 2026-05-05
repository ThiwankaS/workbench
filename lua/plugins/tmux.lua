return {
  {
    -- Seamless movement between Neovim splits and tmux panes.
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Tmux left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Tmux down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Tmux up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Tmux right" },
    },
  },
}
