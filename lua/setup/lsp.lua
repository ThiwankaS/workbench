local M = {}

local servers = { "clangd", "typescript-language-server", "pyright" }

local function capabilities()
  local caps = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp = pcall(require, "cmp_nvim_lsp")
  if ok then
    caps = cmp.default_capabilities(caps)
  end
  return caps
end

function M.setup()
  require("mason").setup()

  vim.schedule(function()
    local ok, registry = pcall(require, "mason-registry")
    if not ok then
      return
    end
    registry.refresh(function()
      for _, name in ipairs(servers) do
        if registry.has_package(name) and not registry.get_package(name):is_installed() then
          registry.get_package(name):install()
        end
      end
    end)
  end)

  local caps = capabilities()

  local function enable(server, opts)
    opts = vim.tbl_deep_extend("force", { capabilities = caps }, opts or {})
    if vim.lsp.config then
      vim.lsp.config(server, opts)
      vim.lsp.enable(server)
    else
      require("lspconfig")[server].setup(opts)
    end
  end

  enable("clangd", {
    filetypes = { "c", "cpp" },
    root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", "CMakeLists.txt", ".git" },
  })
  enable("ts_ls")
  enable("pyright", {
    settings = { python = { analysis = { typeCheckingMode = "basic" } } },
  })
end

M.setup()
