--- Insert-mode Tab / Shift-Tab indent targets for blink.cmp fallback.
--- blink.cmp runs first; when completion/snippets are inactive it calls these mappings.
local M = {}

--- Spaces to the next soft-tab stop (respects shiftwidth / softtabstop / expandtab).
function M.insert_tabstop()
  local col = vim.fn.col(".") - 1
  local sw = vim.bo.softtabstop
  if sw == 0 then
    sw = vim.bo.shiftwidth
  end
  local width = sw - (col % sw)
  if width == 0 then
    width = sw
  end
  if vim.bo.expandtab then
    return string.rep(" ", width)
  end
  return string.rep("\t", 1)
end

function M.setup()
  vim.keymap.set("i", "<Tab>", function()
    return M.insert_tabstop()
  end, { expr = true, desc = "Insert tab / soft indent" })

  vim.keymap.set("i", "<S-Tab>", function()
    return vim.api.nvim_replace_termcodes("<C-d>", true, true, true)
  end, { expr = true, desc = "Unindent in insert mode" })
end

return M
