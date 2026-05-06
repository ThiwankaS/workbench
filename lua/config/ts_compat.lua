-- Legacy plugins (Telescope 0.1.x, etc.) still `require("nvim-treesitter.configs")`.
-- Modern nvim-treesitter no longer ships that module; provide a minimal shim at preload time.
package.preload["nvim-treesitter.configs"] = function()
  local M = {}

  function M.is_enabled(module, lang, bufnr)
    if module ~= "highlight" or not lang or lang == "" then
      return false
    end
    local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang, { error = false })
    return ok and parser ~= nil
  end

  function M.get_module(name)
    if name == "highlight" then
      return {
        enable = true,
        additional_vim_regex_highlighting = false,
      }
    end
    return {}
  end

  return M
end
