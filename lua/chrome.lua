--- NvChad-style UI — powerline statusline + slanted bufferline tabs.
local M = {}

local timer

-- Powerline glyphs (JetBrainsMono Nerd Font) — NvChad default separators
local SEP = {
  l = vim.fn.nr2char(0xe0b6),
  r = vim.fn.nr2char(0xe0bc),
}

local p = {
  bar = "#1d2021",
  tab = "#282828",
  tab_sel = "#3c3836",
  fg = "#ebdbb2",
  muted = "#928374",
  git = "#8ec07c",
  err = "#fb4934",
  warn = "#fabd2f",
  lsp = "#83a598",
  root = "#fb4934",
  pos = "#fabd2f",
  mode = {
    n = "#b8bb26",
    i = "#83a598",
    v = "#d3869b",
    R = "#fe8019",
    c = "#fabd2f",
    t = "#fabd2f",
  },
}

local mode_labels = {
  n = { "NORMAL", "St_NormalMode" },
  i = { "INSERT", "St_InsertMode" },
  R = { "REPLACE", "St_ReplaceMode" },
  c = { "COMMAND", "St_CommandMode" },
  v = { "VISUAL", "St_VisualMode" },
  V = { "V-LINE", "St_VisualMode" },
  ["\22"] = { "V-BLOCK", "St_VisualMode" },
  s = { "SELECT", "St_VisualMode" },
  S = { "S-LINE", "St_VisualMode" },
  t = { "TERMINAL", "St_TerminalMode" },
}

local function hl(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

local function sep_hl(name, fg, bg)
  hl(name, { fg = fg, bg = bg })
end

function M.setup_highlights()
  hl("St_Text", { fg = p.fg, bg = p.bar })
  hl("St_file", { fg = p.fg, bg = p.bar, bold = true })
  sep_hl("St_file_sep", p.bar, p.bar)

  for key, bg in pairs(p.mode) do
    local names = {
      n = "St_NormalMode",
      i = "St_InsertMode",
      v = "St_VisualMode",
      R = "St_ReplaceMode",
      c = "St_CommandMode",
      t = "St_TerminalMode",
    }
    local name = names[key]
    if name then
      hl(name, { fg = p.bar, bg = bg, bold = true })
      sep_hl(name .. "Sep", p.bar, bg)
    end
  end

  hl("St_git", { fg = p.git, bg = p.bar })
  hl("St_lspError", { fg = p.err, bg = p.bar })
  hl("St_lspWarning", { fg = p.warn, bg = p.bar })
  hl("St_LspStatus", { fg = p.lsp, bg = p.bar })
  hl("St_cwd_text", { fg = p.bar, bg = p.root, bold = true })
  sep_hl("St_cwd_sep", p.root, p.bar)
  hl("St_clock", { fg = p.muted, bg = p.bar })
  hl("St_pos_text", { fg = p.bar, bg = p.pos, bold = true })
  sep_hl("St_pos_sep", p.pos, p.bar)
  hl("TbTreeOffset", { fg = p.fg, bg = p.bar, bold = true })
end

local function mode_segment()
  local mode = vim.api.nvim_get_mode().mode
  local info = mode_labels[mode] or { "NORMAL", "St_NormalMode" }
  return "%#" .. info[2] .. "# " .. info[1] .. " %#" .. info[2] .. "Sep#" .. SEP.r .. "%#St_Text#"
end

local function file_segment()
  local name = vim.fn.expand("%:t")
  if name == "" then
    name = "[No Name]"
  end
  if vim.bo.modified then
    name = name .. " ●"
  end
  local icon = "󰈚 "
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if ok then
    local ft_icon = devicons.get_icon_by_filetype(vim.bo.filetype, { default = true })
    if ft_icon then
      icon = ft_icon .. " "
    end
  end
  return "%#St_file#" .. icon .. name
end

local function git_segment()
  local gs = vim.b.gitsigns_status_dict
  if not gs or not gs.head or gs.head == "" then
    return ""
  end
  return "%#St_git#  " .. gs.head
end

local function diag_segment()
  local err = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warn = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local parts = {}
  if err > 0 then
    parts[#parts + 1] = "%#St_lspError#  " .. err
  end
  if warn > 0 then
    parts[#parts + 1] = "%#St_lspWarning#  " .. warn
  end
  return table.concat(parts)
end

local function lsp_segment()
  if vim.bo.filetype == "" or vim.bo.buftype ~= "" then
    return ""
  end
  local get = vim.lsp.get_clients or vim.lsp.get_active_clients
  local clients = get({ bufnr = 0 })
  if #clients == 0 then
    return ""
  end
  return "%#St_LspStatus#  LSP ~ " .. clients[1].name .. " "
end

local function project_segment()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    path = vim.loop.cwd()
  end
  local root = vim.fs.root(path, { ".git", "compile_commands.json", "CMakeLists.txt", "package.json", "pyproject.toml" })
  local name = vim.fn.fnamemodify(root or vim.loop.cwd(), ":t")
  return "%#St_cwd_sep#" .. SEP.l .. "%#St_cwd_text#  " .. name .. " "
end

local function clock_segment()
  return "%#St_clock# " .. os.date("%H:%M")
end

local function position_segment()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return "%#St_pos_sep#" .. SEP.l .. "%#St_pos_text# " .. line .. "/" .. col .. " "
end

function M.setup_statusline()
  vim.o.showmode = false
  vim.o.laststatus = 3

  function _G.workbench_statusline()
    return table.concat({
      mode_segment(),
      file_segment(),
      git_segment(),
      diag_segment(),
      "%=",
      lsp_segment(),
      project_segment(),
      clock_segment(),
      position_segment(),
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

  vim.api.nvim_create_autocmd({
    "ModeChanged",
    "WinEnter",
    "BufEnter",
    "BufWritePost",
    "DiagnosticChanged",
  }, {
    group = vim.api.nvim_create_augroup("chrome_statusline", { clear = true }),
    callback = function()
      vim.schedule(function()
        vim.cmd("redrawstatus!")
      end)
    end,
  })
end

function M.setup_gitsigns()
  require("gitsigns").setup({
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "▎" },
      topdelete = { text = "▎" },
      changedelete = { text = "▎" },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    current_line_blame = false,
  })
end

function M.setup_bufferline()
  require("bufferline").setup({
    options = {
      mode = "buffers",
      separator_style = "slope",
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      show_tab_indicators = false,
      color_icons = true,
      themable = true,
      offsets = {
        {
          filetype = "NvimTree",
          text = "Explorer",
          highlight = "TbTreeOffset",
          separator = true,
        },
      },
    },
    highlights = {
      fill = { bg = p.bar },
      background = { fg = p.muted, bg = p.tab },
      buffer_visible = { fg = p.muted, bg = p.tab },
      buffer_selected = { fg = p.fg, bg = p.tab_sel, bold = true, italic = false },
      separator = { fg = p.bar, bg = p.tab },
      separator_visible = { fg = p.bar, bg = p.tab },
      separator_selected = { fg = p.bar, bg = p.tab_sel },
      indicator_selected = { fg = p.tab_sel, bg = p.tab_sel },
      close_button = { fg = p.muted, bg = p.tab },
      close_button_visible = { fg = p.muted, bg = p.tab },
      close_button_selected = { fg = p.fg, bg = p.tab_sel },
      offset_separator = { fg = p.tab, bg = p.bar },
    },
  })
end

function M.setup()
  M.setup_highlights()
  M.setup_statusline()
end

return M
