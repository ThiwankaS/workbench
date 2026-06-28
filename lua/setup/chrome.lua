local M = {}

-- Colors mapped directly from your original config and Gruvbox theme
local colors = {
  bar      = "#1d2021",
  tab      = "#282828",
  tab_sel  = "#3c3836",
  text     = "#ebdbb2",
  normal   = "#b8bb26",
  insert   = "#83a598",
  visual   = "#d3869b",
  replace  = "#fe8019",
  command  = "#fabd2f",
  git      = "#8ec07c",
  error    = "#fb4934",
  warn     = "#fabd2f",
  clock    = "#928374",
}

-- Custom theme layout matching your NvChad-style blocks
local nvchad_theme = {
  normal = {
    a = { fg = colors.bar, bg = colors.normal, bold = true },
    b = { fg = colors.text, bg = colors.bar },
    c = { fg = colors.text, bg = colors.bar },
  },
  insert = { a = { fg = colors.bar, bg = colors.insert, bold = true } },
  visual = { a = { fg = colors.bar, bg = colors.visual, bold = true } },
  replace = { a = { fg = colors.bar, bg = colors.replace, bold = true } },
  command = { a = { fg = colors.bar, bg = colors.command, bold = true } },
  inactive = {
    a = { fg = colors.clock, bg = colors.bar },
    b = { fg = colors.clock, bg = colors.bar },
    c = { fg = colors.clock, bg = colors.bar },
  },
}

function M.setup()
  -- 1. Setup Gitsigns (Maintained from your source)
  require("gitsigns").setup({
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "▎" },
    },
    signcolumn = true,
  })

  -- 2. Setup Bufferline (Tabline approach maintained from your source)
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
      fill = { bg = colors.bar },
      background = { fg = colors.clock, bg = colors.tab },
      buffer_selected = { fg = colors.text, bg = colors.tab_sel, bold = true },
      separator = { fg = colors.bar, bg = colors.tab },
      separator_selected = { fg = colors.bar, bg = colors.tab_sel },
      offset_separator = { fg = colors.tab, bg = colors.bar },
    },
  })

  -- 3. Setup Lualine (Replacing your custom 70-line string builder + looping timer)
  require("lualine").setup({
    options = {
      theme = nvchad_theme,
      component_separators = "",
      -- This matches your Powerline character codes: vim.fn.nr2char(0xe0b6) / 0xe0bc
      section_separators = { left = "", right = "" }, 
      disabled_filetypes = { statusline = { "NvimTree" } },
      globalstatus = true,
    },
    sections = {
      lualine_a = { { "mode", separator = { right = "" }, right_padding = 2 } },
      lualine_b = { 
        { "filename", file_status = true, path = 0 },
        { "branch", icon = "  ", color = { fg = colors.git } } 
      },
      lualine_c = {
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          sections = { "error", "warn" },
          diagnostics_color = {
            error = { fg = colors.error },
            warn = { fg = colors.warn },
          },
        },
      },
      lualine_x = {
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            return #clients > 0 and ("LSP ~ " .. clients[1].name) or ""
          end,
          color = { fg = colors.insert },
        },
      },
      lualine_y = {
        {
          function()
            local path = vim.api.nvim_buf_get_name(0)
            if path == "" then path = vim.uv.cwd() end
            -- Dynamically extracts your root folder using the same markers as your lsp configuration
            local root = vim.fs.root(path, { ".git", "compile_commands.json", "CMakeLists.txt", "package.json" })
            return " " .. vim.fn.fnamemodify(root or vim.uv.cwd(), ":t") .. " "
          end,
          color = { fg = colors.bar, bg = colors.error, bold = true },
          separator = { left = "" },
        },
        {
          function() return os.date("%H:%M") end,
          color = { fg = colors.clock, bg = colors.bar },
        }
      },
      lualine_z = {
        { "location", separator = { left = "" }, left_padding = 2, color = { fg = colors.bar, bg = colors.command, bold = true } }
      },
    },
  })
end

M.setup()