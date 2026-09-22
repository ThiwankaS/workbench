--- English spell checking. Treesitter `@spell` limits code buffers to comments
--- and strings; prose filetypes are checked in full. Harper (see setup/lsp.lua)
--- adds grammar diagnostics on markdown, git commits, text, and Typst.
local ft = require("core.filetypes")
local opt = vim.opt

local spell_dir = vim.fn.stdpath("data") .. "/spell"
vim.fn.mkdir(spell_dir, "p")

opt.spelllang = { "en" }
opt.spelloptions = "camel"
opt.spellsuggest = "best,9"
opt.spellfile = spell_dir .. "/en.utf-8.add"

local group = vim.api.nvim_create_augroup("workbench_spell", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function(args)
    local filetype = vim.bo[args.buf].filetype
    if ft.ui_plugin[filetype] or ft.spell_skip[filetype] then
      vim.opt_local.spell = false
      return
    end
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  callback = function()
    vim.opt_local.spell = false
  end,
})
