-- NvUI / Base46 user config — see :h nvui
return {
  base46 = {
    theme = "gruvbox",
    transparency = true,
    theme_toggle = { "gruvbox", "gruvbox" },
    integrations = {},
    hl_add = {},
    hl_override = {},
    changed_themes = {},
  },

  ui = {
    statusline = {
      enabled = true,
      theme = "default",
      separator_style = "arrow",
      order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "clock", "cursor" },
      modules = {
        clock = function()
          return require("setup.clock").statusline()
        end,
      },
    },
    tabufline = {
      enabled = true,
      lazyload = false,
      treeOffsetFt = "NvimTree",
    },
    telescope = { style = "borderless" },
    cmp = { style = "default" },
  },

  nvdash = { load_on_startup = false },
  lsp = { signature = true },
  colorify = { enabled = true, mode = "virtual" },
  mason = { pkgs = {}, skip = {} },
}
