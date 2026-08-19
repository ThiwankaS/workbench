--- Mason + LSP servers and buffer-local LSP keymaps (gd, gr, Space k, etc.).
local config = require("config")
local ft = require("core.filetypes")
local M = {}

local function capabilities()
  local caps = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp = pcall(require, "cmp_nvim_lsp")
  if ok then
    caps = cmp.default_capabilities(caps)
  end
  return caps
end

local function attach_keymaps(buf)
  if ft.lsp_skip[vim.bo[buf].filetype] then
    return
  end

  local function bmap(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true, noremap = true })
  end

  bmap("n", "gd", vim.lsp.buf.definition, "Definition")
  bmap("n", "gr", vim.lsp.buf.references, "References")
  bmap("n", "gi", vim.lsp.buf.implementation, "Implementation")
  bmap("n", "gt", vim.lsp.buf.type_definition, "Type definition")
  bmap("n", "<leader>k", vim.lsp.buf.hover, "Hover")
  bmap("n", "<leader>n", vim.lsp.buf.rename, "Rename")
  bmap({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, "Code action")
  bmap("n", "<leader>m", function()
    vim.lsp.buf.format({ async = true })
  end, "Format")
end

function M.setup()
  require("mason").setup()

  vim.schedule(function()
    local ok, registry = pcall(require, "mason-registry")
    if not ok then
      return
    end
    registry.refresh(function()
      for _, name in ipairs(config.lsp_servers) do
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
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--function-arg-placeholders=true",
    },
  })
  enable("ts_ls")
  enable("pyright", {
    settings = { python = { analysis = { typeCheckingMode = "basic" } } },
  })
  enable("dockerls", {
    filetypes = { "dockerfile" },
    -- Attach even when there is no Dockerfile at the repo root (e.g. *.docker in .devcontainer/).
    root_markers = { "Dockerfile", ".dockerfile", ".git" },
    single_file_support = true,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("workbench_lsp", { clear = true }),
    callback = function(args)
      local buf = args.buf

      -- Neovim 0.11+ built-in completion conflicts with nvim-cmp Enter handling
      if vim.lsp.completion and vim.lsp.completion.enable then
        pcall(vim.lsp.completion.enable, false, args.data.client_id, buf)
      end

      attach_keymaps(buf)
    end,
  })
end

return M
