--- Palette + highlight overrides for Treesitter + LSP semantic tokens (base46 `hl_override`).
--- Use base46 Gruvbox color names (not Catppuccin names like lavender/mauve/peach).
vim.theme = vim.theme or {}

vim.theme.syntax = vim.tbl_deep_extend("force", {
  keyword_type = "dark_purple",
  type = "yellow",
  type_builtin = "yellow",
  preproc_arg = "orange",

  func = "nord_blue",
  func_call = "nord_blue",
  constructor = "nord_blue",
  method = "teal",
  method_call = "teal",

  namespace = "yellow",
  variable = "purple",
  parameter = "orange",
  field = "purple",
  variable_builtin = "red",
  property = "teal",

  operator = "cyan",
  keyword_operator = "pink",
  punctuation = "grey_fg",
}, vim.theme.syntax or {})

local M = {}

local function fgp(role, fallback)
  local v = vim.theme.syntax[role]
  if type(v) == "string" then
    return v
  end
  return fallback
end

local function pair_rows(rows)
  local out = {}
  for _, row in ipairs(rows) do
    local hl_name, role_key, fb = row[1], row[2], row[3]
    out[hl_name] = { fg = fgp(role_key, fb) }
  end
  return out
end

local function treesitter_caps()
  local r = {
    { "@function.call", "func_call", "nord_blue" },
    { "@function", "func", "nord_blue" },
    { "@function.method.call", "method_call", "teal" },
    { "@function.method", "method", "teal" },
    { "@constructor", "constructor", "nord_blue" },
    { "@type.builtin", "type_builtin", "yellow" },
    { "@namespace", "namespace", "yellow" },
    { "@variable", "variable", "purple" },
    { "@variable.parameter", "parameter", "orange" },
    { "@variable.member", "field", "purple" },
    { "@variable.builtin", "variable_builtin", "red" },
    { "@operator", "operator", "cyan" },
    { "@punctuation.delimiter", "punctuation", "grey_fg" },
    { "@punctuation.bracket", "punctuation", "grey_fg" },
    { "@keyword.operator", "keyword_operator", "pink" },
    { "@property", "property", "teal" },
  }

  local out = {}
  for _, row in ipairs(r) do
    local base, role_key, fb = row[1], row[2], row[3]
    local spec = { fg = fgp(role_key, fb) }
    out[base] = spec
    out[base .. ".c"] = spec
    out[base .. ".cpp"] = spec
  end

  out["@keyword.type.c"] = { fg = fgp("keyword_type", "dark_purple") }
  out["@keyword.type.cpp"] = { fg = fgp("keyword_type", "dark_purple") }
  out["@type.c"] = { fg = fgp("type", "yellow") }
  out["@type.cpp"] = { fg = fgp("type", "yellow") }
  out["@preproc.arg"] = { fg = fgp("preproc_arg", "orange") }

  return out
end

local function lsp_semantic_caps()
  return pair_rows({
    { "@lsp.type.function", "func_call", "nord_blue" },
    { "@lsp.type.method", "method_call", "teal" },
    { "@lsp.type.namespace", "namespace", "yellow" },
    { "@lsp.type.parameter", "parameter", "orange" },
    { "@lsp.type.variable", "variable", "purple" },
    { "@lsp.type.property", "field", "purple" },
    { "@lsp.type.class", "type", "yellow" },
    { "@lsp.type.enum", "type", "yellow" },
    { "@lsp.type.typeParameter", "type", "yellow" },
    { "@lsp.type.decorator", "namespace", "yellow" },
    { "@lsp.mod.readonly", "variable_builtin", "red" },
  })
end

--- Used by `chadrc.lua` as `base46.hl_override`.
function M.hl_override()
  return vim.tbl_deep_extend("force", treesitter_caps(), lsp_semantic_caps())
end

return M
