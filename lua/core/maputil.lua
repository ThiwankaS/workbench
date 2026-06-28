-- Shared helpers so global keymaps do not steal keys from trees, pickers, etc.
local M = {}

--- Filetypes where global leader / buffer maps should not run.
M.blocked_ft = {
  NvimTree = true,
  TelescopePrompt = true,
  TelescopeResults = true,
  spectre_panel = true,
  DressingInput = true,
  mason = true,
}

function M.ft_blocked()
  return M.blocked_ft[vim.bo.filetype] == true
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
    vim.cmd(cmd)
  end, opts)
end

return M
