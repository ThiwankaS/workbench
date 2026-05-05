-- Group all user autocmds so they can be managed together.
local augroup = vim.api.nvim_create_augroup("user_config", { clear = true })

-- Briefly highlight yanked text for visual feedback.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Disable auto-inserting comment leader on new lines after comments.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})
