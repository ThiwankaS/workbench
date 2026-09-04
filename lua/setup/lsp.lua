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
  bmap("i", "<M-k>", vim.lsp.buf.signature_help, "Signature help")
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
  enable("ts_ls", {
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  })
  enable("pyright", {
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
    settings = { python = { analysis = { typeCheckingMode = "basic" } } },
  })
  enable("dockerls", {
    filetypes = { "dockerfile" },
    -- Attach even when there is no Dockerfile at the repo root (e.g. *.docker in .devcontainer/).
    root_markers = { "Dockerfile", ".dockerfile", ".git" },
    single_file_support = true,
  })
  enable("neocmake", {
    filetypes = { "cmake" },
    root_markers = { ".neocmake.toml", "CMakeLists.txt", "build", ".git" },
    init_options = {
      format = { enable = true },
      lint = { enable = true },
      -- Prefer Treesitter highlight; neocmake tokens can crash Neovim's decoder.
      semantic_token = false,
    },
  })
  enable("qmlls", {
    cmd = vim.fn.executable("qmlls6") == 1 and { "qmlls6" } or { "qmlls" },
    filetypes = { "qml", "qmljs" },
    root_markers = { ".qmlls.ini", "CMakeLists.txt", ".git" },
  })
  enable("tinymist", {
    filetypes = { "typst" },
    root_markers = { "typst.toml", "cv.typ", ".git" },
    single_file_support = true,
    settings = {
      formatterMode = "typstyle",
      exportPdf = "onSave",
      outputPath = "$root/$name",
    },
  })

  -- Servers whose semantic-token payloads can crash Neovim's decoder
  -- (nil arithmetic in vim.lsp.semantic_tokens). Treesitter already highlights.
  local no_semantic_tokens = {
    qmlls = true,
    neocmake = true,
  }

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("workbench_lsp", { clear = true }),
    callback = function(args)
      local buf = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      -- Neovim 0.11+ built-in completion conflicts with nvim-cmp Enter handling
      if vim.lsp.completion and vim.lsp.completion.enable then
        pcall(vim.lsp.completion.enable, false, args.data.client_id, buf)
      end

      if client and no_semantic_tokens[client.name] then
        client.server_capabilities.semanticTokensProvider = nil
      end

      attach_keymaps(buf)

      -- Pin cv.typ so editing template.typ still previews the CV.
      if client and client.name == "tinymist" then
        local root = vim.fs.root(buf, { "typst.toml", "cv.typ", ".git" })
        local main = root and (root .. "/cv.typ") or vim.api.nvim_buf_get_name(buf)
        if vim.fn.filereadable(main) == 1 then
          pcall(function()
            client:exec_cmd({
              title = "Pin Typst main",
              command = "tinymist.pinMain",
              arguments = { main },
            })
          end)
        end
      end
    end,
  })
end

return M
