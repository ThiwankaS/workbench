--- Synchronous LSP setup: NvChad defaults + blink capabilities + essential servers.
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

function M.setup()
  nvchad.defaults()

  local caps = nvchad.capabilities
  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    caps = vim.tbl_deep_extend("force", caps, blink.get_lsp_capabilities({}))
  end

  vim.lsp.config("*", {
    capabilities = caps,
    on_init = nvchad.on_init,
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

  vim.lsp.config("clangd", clangd_config())

  for _, server in ipairs(SERVERS) do
    vim.lsp.enable(server)
  end

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
