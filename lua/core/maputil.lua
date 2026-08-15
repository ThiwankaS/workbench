--- Guard helpers: global keymaps must not steal keys from trees, pickers, etc.
local ft = require("core.filetypes")
local M = {}

function M.ft_blocked()
  return ft.ui_plugin[vim.bo.filetype] == true
end

function M.guard(fn, opts)
  opts = opts or {}
  return function()
    if M.ft_blocked() then
      if opts.fallback then
        opts.fallback()
      end
      return
    end
    fn()
  end
end

function M.guard_cmd(cmd, opts)
  return M.guard(function()
    if cmd == "q" and vim.bo.modified then
      vim.cmd("confirm q")
      return
    end
    local ok = pcall(vim.cmd, cmd)
    if not ok and cmd == "q" then
      vim.cmd("confirm q")
    end
  end, opts)
end

return M
