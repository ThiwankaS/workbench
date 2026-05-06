--- Single place for **clang-format** / Conform behavior.
--- Prefer a `.clang-format` in your repo root (`-style=file` is implied by clang-format defaults).
---
--- Fallback style applies when no file/config is found. Common values: `"LLVM"`, `"Google"`, `"Chromium"`, `"Mozilla"`, `"GNU"`.

return {

  clang_format_exe = nil, -- Override binary; nil uses `clang-format` from PATH.

  clang_format_fallback_style = "LLVM",

  -- Passed before file arguments (e.g. `"-assume-filename=foo.cpp"`).
  clang_format_prepend_args = {},

  format_on_save = false,

  timeout_ms = 750,
}
