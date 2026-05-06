--- Single place for syntax highlight tweaks used by NvChad `chadrc.lua` (`base46.hl_override`).
--- Use base46 palette **names** for the active Catppuccin preset (examples: lavender, teal, peach),
--- or a hex string `#RRGGBB` when NvChad supports it for overrides.
vim.theme = vim.theme or {}

vim.theme.syntax = vim.tbl_deep_extend("force", {
  keyword_type = "mauve",
  type = "yellow",
  preproc_arg = "peach",
}, vim.theme.syntax or {})

local role_alias = {
  keyword = "keyword_type",
  type = "type",
  preproc = "preproc_arg",
}
setmetatable(vim.theme, {
  __index = function(_, k)
    local r = role_alias[k]
    if r then
      return vim.theme.syntax[r]
    end
    return nil
  end,
  __newindex = function(_, k, v)
    local r = role_alias[k]
    if r then
      vim.theme.syntax[r] = v
      return
    end
    rawset(vim.theme, k, v)
  end,
})

return {}
