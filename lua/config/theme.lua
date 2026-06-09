--- =============================================================================
--- SYNTAX COLORS — edit `vim.theme.syntax` below, then :WorkbenchThemeReload
--- =============================================================================
--- File: lua/config/theme.lua
--- Maps Gruvbox-style roles → Treesitter @-groups for C/C++.
--- LSP semantic tokens are OFF (see configs/lspconfig.lua); Treesitter paints code.
--- =============================================================================
vim.theme = vim.theme or {}

vim.theme.syntax = vim.tbl_deep_extend("force", {
  -- Control flow
  keyword = "#fb4934",
  keyword_type = "#fb4934",
  keyword_modifier = "#fe8019",
  keyword_exception = "#fb4934",
  keyword_operator = "#fb4934",

  -- Types
  type = "#fabd2f",
  type_builtin = "#d79921",

  -- Functions (declarations vs calls use different hues)
  func = "#83a598",
  func_call = "#fabd2f",
  method = "#8ec07c",
  method_call = "#fabd2f",
  constructor = "#fabd2f",

  -- Namespaces
  namespace = "#83a598",
  module = "#83a598",

  -- Variables
  variable = "#ebdbb2",
  parameter = "#fe8019",
  field = "#d3869b",
  property = "#d3869b",
  variable_builtin = "#fb4934",

  -- Constants & macros — steel blue (not teal like @function #83a598)
  constant = "#729fcf",
  constant_macro = "#729fcf",
  constant_builtin = "#729fcf",

  -- Literals
  string = "#b8bb26",
  number = "#d3869b",
  boolean = "#fb4934",

  -- Misc
  operator = "#a89984",
  punctuation = "#a89984",
  comment = "#928374",
  preproc = "#8ec07c",
  preproc_arg = "#fe8019",
  label = "#fe8019",
  attribute = "#fe8019",
}, vim.theme.syntax or {})

-- Treesitter capture → syntax role (+ optional highlight opts).
local CAPTURES = {
  { "@keyword", "keyword" },
  { "@keyword.return", "keyword" },
  { "@keyword.conditional", "keyword" },
  { "@keyword.repeat", "keyword" },
  { "@keyword.modifier", "keyword_modifier" },
  { "@keyword.type", "keyword_type" },
  { "@keyword.operator", "keyword_operator" },
  { "@keyword.import", "preproc" },
  { "@keyword.directive", "preproc" },
  { "@keyword.exception", "keyword_exception" },
  { "@keyword.coroutine", "keyword" },

  { "@type", "type" },
  { "@type.builtin", "type_builtin" },
  { "@type.definition", "type" },

  { "@function", "func" },
  { "@function.call", "func_call" },
  { "@function.builtin", "func_call" },
  { "@function.method", "method" },
  { "@function.method.call", "method_call" },
  { "@constructor", "constructor" },

  { "@variable", "variable" },
  { "@variable.parameter", "parameter", { italic = true } },
  { "@variable.member", "field" },
  { "@variable.builtin", "variable_builtin" },
  { "@field", "field" },
  { "@property", "property" },

  { "@namespace", "namespace" },
  { "@module", "module", { italic = true } },
  { "@constant", "constant" },
  { "@constant.builtin", "constant_builtin" },
  { "@constant.macro", "constant_macro" },
  { "@label", "label" },

  { "@operator", "operator" },
  { "@punctuation.delimiter", "punctuation" },
  { "@punctuation.bracket", "punctuation" },
  { "@punctuation.special", "punctuation" },
  { "@string", "string" },
  { "@string.regex", "string" },
  { "@character", "string" },
  { "@number", "number" },
  { "@number.float", "number" },
  { "@boolean", "boolean" },
  { "@comment", "comment", { italic = true } },
  { "@comment.documentation", "comment", { italic = true } },
  { "@attribute", "attribute" },
  { "@preproc", "preproc" },
  { "@preproc.arg", "preproc_arg" },
}

local M = {}

local function hex(role)
  local v = vim.theme.syntax[role]
  if type(v) == "string" and v:sub(1, 1) == "#" then
    return v
  end
  return "#ebdbb2"
end

local function hl_spec(role, opts)
  return vim.tbl_extend("force", { fg = hex(role) }, opts or {})
end

local function with_ft(out, base, spec)
  out[base] = spec
  out[base .. ".c"] = vim.deepcopy(spec)
  out[base .. ".cpp"] = vim.deepcopy(spec)
end

local function treesitter_caps()
  local out = {}
  for _, row in ipairs(CAPTURES) do
    local capture, role, opts = row[1], row[2], row[3]
    with_ft(out, capture, hl_spec(role, opts))
  end
  return out
end

--- base46 `hl_override` — baked when chadrc loads; use :WorkbenchThemeReload after edits.
function M.hl_override()
  return treesitter_caps()
end

--- Runtime apply (after NvChad reloads cached treesitter highlights on BufReadPost).
function M.apply_treesitter_hl()
  for name, spec in pairs(treesitter_caps()) do
    vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", spec, { force = true }))
  end
end

local hl_gen = 0

--- Debounced apply — used from autocmds.lua on buffer open / theme events.
function M.schedule_apply(delay)
  hl_gen = hl_gen + 1
  local gen = hl_gen
  vim.defer_fn(function()
    if gen == hl_gen then
      M.apply_treesitter_hl()
    end
  end, delay or 80)
end

--- Full reload: rebuild base46 cache from chadrc + re-apply Treesitter colors.
function M.reload()
  package.loaded["chadrc"] = nil
  package.loaded["nvconfig"] = nil
  local ok, err = pcall(require("base46").load_all_highlights)
  if not ok then
    vim.notify("WorkbenchThemeReload: " .. tostring(err), vim.log.levels.WARN)
  end
  M.apply_treesitter_hl()
end

return M
