-- Blink.cmp extends LSP capabilities (completion kinds, etc.). Merge with NvChad defaults.
do
  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    local nvchad = require("nvchad.configs.lspconfig")
    vim.lsp.config("*", {
      capabilities = blink.get_lsp_capabilities(nvchad.capabilities),
    })
  end
end

-- NvChad disables semantic tokens for every client for compatibility. Clangd uses them heavily for
-- readable highlighting (@lsp.type.* → hl groups). This handler duplicates NvChad's strip logic but
-- skips clangd. Loaded after NvChad's nvim-lspconfig config (lower Lazy priority) so it merges
-- into vim.lsp.config("*") and replaces only `on_init`; NvChad capabilities stay intact.
vim.lsp.config("*", {
  on_init = function(client, _)
    if client.name == "clangd" then
      return
    end
    if vim.fn.has("nvim-0.11") ~= 1 then
      if client.supports_method("textDocument/semanticTokens") then
        client.server_capabilities.semanticTokensProvider = nil
      end
    else
      if client:supports_method("textDocument/semanticTokens") then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end
  end,
})

-- Keep nvim's bundled clangd extras (editsNearCursor, utf-8/utf-16); merge preserves them when set here too.
-- Prefer PATH, then Mason (NvChad often installs clangd there; FilePost may run before Mason is on PATH).
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

vim.lsp.config("clangd", {
  cmd = {
    clangd_executable(),
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
    "--function-arg-placeholders",
    "--pch-storage=memory",
  },
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
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
})

-- NvChad lazy-loads nvim-lspconfig on `User FilePost` (after UIEnter + real file). That can run
-- *after* VimEnter, so a VimEnter-only `vim.lsp.enable` never fired and clangd never started — only
-- snippets/buffer completion appeared. Enable when this config runs if startup already finished,
-- else defer to VimEnter (same idea as nvim-lite’s immediate enable at end of init).
do
  local servers = {
    "clangd",
    "ts_ls",
    "pyright",
    "bashls",
    "marksman",
  }

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
end

-- Hint once per session when clangd has no usable compilation database (weak completion / no members).
do
  local warned = {}
  vim.api.nvim_create_autocmd("LspAttach", {
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
              .. "/ — symlink it to the project root or add .clangd with CompilationDatabase: "
              .. sub,
            vim.log.levels.WARN,
            { title = "clangd" }
          )
          return
        end
      end
      warned[root] = true
      vim.notify(
        "clangd: no compile_commands.json — C/C++ completion may lack members and stdlib. "
          .. "Generate one (e.g. cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON) or use compile_flags.txt.",
        vim.log.levels.WARN,
        { title = "clangd" }
      )
    end,
  })
end
