--- Single LSP entry point. Runs after NvChad `FilePost` so blink capabilities are not overwritten.
local M = {}

local nvchad = require("nvchad.configs.lspconfig")

local SERVERS = { "clangd", "lua_ls", "ts_ls", "pyright", "bashls", "marksman" }

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

local function disable_semantic_tokens(client)
  if vim.fn.has("nvim-0.11") ~= 1 then
    if client.supports_method("textDocument/semanticTokens") then
      client.server_capabilities.semanticTokensProvider = nil
    end
  elseif client:supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

function M.on_init(client, _)
  disable_semantic_tokens(client)
end

function M.apply_globals()
  dofile(vim.g.base46_cache .. "lsp")
  require("nvchad.lsp").diagnostic_config()

  local caps = nvchad.capabilities
  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    caps = blink.get_lsp_capabilities(caps)
  end

  vim.lsp.config("*", {
    capabilities = caps,
    on_init = M.on_init,
  })

  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = {
          library = {
            vim.fn.expand("$VIMRUNTIME/lua"),
            vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
            vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
            "${3rd}/luv/library",
          },
        },
      },
    },
  })
end

local function clangd_config()
  local cmd = {
    clangd_executable(),
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
    "--function-arg-placeholders",
    "--pch-storage=memory",
  }
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
end

vim.lsp.config("clangd", clangd_config())

function M.enable_servers()
  vim.lsp.enable(SERVERS)
end

function M.setup()
  local lsp_group = vim.api.nvim_create_augroup("workbench_lsp", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_group,
    callback = function(args)
      nvchad.on_attach(_, args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    group = lsp_group,
    pattern = "FilePost",
    callback = function()
      vim.schedule(function()
        M.apply_globals()
        M.enable_servers()
      end)
    end,
  })

  local warned = {}
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("workbench_clangd_hint", { clear = true }),
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

return M
