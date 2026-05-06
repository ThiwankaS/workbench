local F = require("config.format")

local clang_prep = vim.deepcopy(F.clang_format_prepend_args or {})
table.insert(clang_prep, "--fallback-style=" .. (F.clang_format_fallback_style or "LLVM"))

local formatters = {
  clang_format = {
    prepend_args = clang_prep,
  },
}

if F.clang_format_exe and F.clang_format_exe ~= "" then
  formatters.clang_format.command = F.clang_format_exe
end

local opts = {
  formatters_by_ft = {
    lua = { "stylua" },
    c = { "clang_format" },
    cpp = { "clang_format" },
  },
  formatters = formatters,
}

if F.format_on_save then
  opts.format_on_save = {
    quiet = false,
    timeout_ms = F.timeout_ms,
    lsp_fallback = true,
  }
end

return opts
