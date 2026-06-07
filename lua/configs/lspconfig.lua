--- LSP setup: blink capabilities, semantic-token disable, clangd, server enable.
--- Loaded from `lua/plugins/init.lua` after NvChad's lspconfig spec.

-- Merge blink.cmp capabilities with NvChad defaults.
do
  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    local nvchad = require("nvchad.configs.lspconfig")
    vim.lsp.config("*", {
      capabilities = blink.get_lsp_capabilities(nvchad.capabilities),
    })
  end
end

-- Treesitter handles syntax; LSP semantic tokens override with a flat layer — off for all clients.
vim.lsp.config("*", {
  on_init = function(client, _)
    if vim.fn.has("nvim-0.11") ~= 1 then
      if client.supports_method("textDocument/semanticTokens") then
        client.server_capabilities.semanticTokensProvider = nil
      end
    elseif client:supports_method("textDocument/semanticTokens") then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

local function clangd_executable()
  if vim.fn.executable("clangd") == 1 then
    return "clangd"
  end
  local mason = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", "clangd")
  if vim.fn.executable(mason) == 1 then
    return mason
  end
  return "clangd"
end

vim.lsp.config("clangd", (function()
  local cmd = {
    clangd_executable(),
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
    "--function-arg-placeholders",
    "--pch-storage=memory",
  }
  -- ESP-IDF / cross-GCC: export CLANGD_QUERY_DRIVER="$HOME/.espressif/tools/**/bin/*-gcc,..."
  local qd = vim.env.CLANGD_QUERY_DRIVER
  if qd and qd ~= "" then
    table.insert(cmd, "--query-driver=" .. qd)
  end
  return {
    cmd = cmd,
    capabilities = {
      textDocument = {
        completion = { editsNearCursor = true },
      },
      offsetEncoding = { "utf-8", "utf-16" },
    },
    init_options = {
      clangdFileStatus = true,
      usePlaceholders = true,
      completeUnimported = true,
    },
    root_markers = {
      "compile_commands.json",
      "compile_flags.txt",
      ".clangd",
      "CMakeLists.txt",
      ".git",
    },
  }
end)())

-- Enable servers (NvChad may load lspconfig after VimEnter).
local servers = { "clangd", "ts_ls", "pyright", "bashls", "marksman" }

local function enable_lsps()
  vim.schedule(function()
    vim.lsp.enable(servers)
  end)
end

if vim.v.vim_did_enter == 1 then
  enable_lsps()
else
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = enable_lsps,
  })
end

-- One-time hint when clangd has no compile_commands.json.
do
  local warned = {}
  local lsp_group = vim.api.nvim_create_augroup("user_lsp", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_group,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client or client.name ~= "clangd" then
        return
      end
      local root = client.root_dir
      if not root or warned[root] then
        return
      end
      local function compile_db(path)
        return path and vim.uv.fs_stat(path .. "/compile_commands.json") ~= nil
      end
      if compile_db(root) then
        return
      end
      for _, sub in ipairs({ "build", "cmake-build-debug", "out", "cmake-build-release", "debug", "Release" }) do
        if compile_db(root .. "/" .. sub) then
          warned[root] = true
          vim.notify(
            "clangd: compile_commands.json is in "
              .. sub
              .. "/ — symlink to project root or set .clangd CompilationDatabase",
            vim.log.levels.WARN,
            { title = "clangd" }
          )
          return
        end
      end
      warned[root] = true
      vim.notify(
        "clangd: no compile_commands.json — add compile_flags.txt or generate with CMake.",
        vim.log.levels.WARN,
        { title = "clangd" }
      )
    end,
  })
end
