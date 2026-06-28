--- NvChad-style tabline + powerline statusline (no NvChad framework).
local M = {}

local timer
local SEP = { l = vim.fn.nr2char(0xe0b6), r = vim.fn.nr2char(0xe0bc) }
local bar = "#1d2021"
local tab = "#282828"
local tab_sel = "#3c3836"

local modes = {
  n = { "NORMAL", "St_NormalMode", "#b8bb26" },
  i = { "INSERT", "St_InsertMode", "#83a598" },
  v = { "VISUAL", "St_VisualMode", "#d3869b" },
  V = { "V-LINE", "St_VisualMode", "#d3869b" },
  R = { "REPLACE", "St_ReplaceMode", "#fe8019" },
  c = { "COMMAND", "St_CommandMode", "#fabd2f" },
  t = { "TERMINAL", "St_TerminalMode", "#fabd2f" },
}

local function hl(name, fg, bg, bold)
  vim.api.nvim_set_hl(0, name, { fg = fg, bg = bg, bold = bold or false })
end

function M.setup()
  for _, m in pairs(modes) do
    hl(m[2], bar, m[3], true)
    hl(m[2] .. "Sep", bar, m[3])
  end
  hl("St_Text", "#ebdbb2", bar, true)
  hl("St_git", "#8ec07c", bar)
  hl("St_lspError", "#fb4934", bar)
  hl("St_lspWarning", "#fabd2f", bar)
  hl("St_LspStatus", "#83a598", bar)
  hl("St_cwd_text", bar, "#fb4934", true)
  hl("St_cwd_sep", "#fb4934", bar)
  hl("St_clock", "#928374", bar)
  hl("St_pos_text", bar, "#fabd2f", true)
  hl("St_pos_sep", "#fabd2f", bar)
  hl("TbTreeOffset", "#ebdbb2", bar, true)

  require("gitsigns").setup({
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "▎" },
    },
    signcolumn = true,
  })

  require("bufferline").setup({
    options = {
      separator_style = "slope",
      diagnostics = "nvim_lsp",
      show_close_icon = false,
      show_tab_indicators = false,
      offsets = {
        { filetype = "NvimTree", text = "Explorer", highlight = "TbTreeOffset", separator = true },
      },
    },
    highlights = {
      fill = { bg = bar },
      background = { fg = "#928374", bg = tab },
      buffer_selected = { fg = "#ebdbb2", bg = tab_sel, bold = true },
      separator = { fg = bar, bg = tab },
      separator_selected = { fg = bar, bg = tab_sel },
      offset_separator = { fg = tab, bg = bar },
    },
  })

  function _G.workbench_statusline()
    local mode = vim.api.nvim_get_mode().mode
    local m = modes[mode] or modes.n
    local file = vim.fn.expand("%:t")
    if file == "" then
      file = "[No Name]"
    end
    if vim.bo.modified then
      file = file .. " ●"
    end

    local git = ""
    local gs = vim.b.gitsigns_status_dict
    if gs and gs.head and gs.head ~= "" then
      git = "%#St_git#  " .. gs.head
    end

    local err = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warn = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local diag = ""
    if err > 0 then
      diag = diag .. "%#St_lspError#  " .. err
    end
    if warn > 0 then
      diag = diag .. "%#St_lspWarning#  " .. warn
    end

    local lsp = ""
    local get = vim.lsp.get_clients or vim.lsp.get_active_clients
    local clients = get({ bufnr = 0 })
    if #clients > 0 then
      lsp = "%#St_LspStatus#  LSP ~ " .. clients[1].name .. " "
    end

    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then
      path = vim.loop.cwd()
    end
    local root = vim.fs.root(path, { ".git", "compile_commands.json", "CMakeLists.txt", "package.json" })
    local proj = vim.fn.fnamemodify(root or vim.loop.cwd(), ":t")
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))

    return table.concat({
      "%#" .. m[2] .. "# " .. m[1] .. " %#" .. m[2] .. "Sep#" .. SEP.r,
      "%#St_Text#  " .. file,
      git,
      diag,
      "%=",
      lsp,
      "%#St_cwd_sep#" .. SEP.l .. "%#St_cwd_text#  " .. proj .. " ",
      "%#St_clock# " .. os.date("%H:%M"),
      "%#St_pos_sep#" .. SEP.l .. "%#St_pos_text# " .. line .. "/" .. col .. " ",
    })
  end

  vim.opt.statusline = "%!v:lua.workbench_statusline()"

  if timer then
    timer:stop()
    timer:close()
  end
  timer = vim.uv.new_timer()
  timer:start(1000, 30000, vim.schedule_wrap(function()
    vim.cmd("redrawstatus!")
  end))

  vim.api.nvim_create_autocmd({ "ModeChanged", "WinEnter", "BufEnter", "DiagnosticChanged" }, {
    group = vim.api.nvim_create_augroup("chrome", { clear = true }),
    callback = function()
      vim.schedule(function()
        vim.cmd("redrawstatus!")
      end)
    end,
  })
end

M.setup()
