--- User autocmds (extends nvchad.autocmds).
require("nvchad.autocmds")

local theme = require("config.theme")
local augroup = vim.api.nvim_create_augroup("user_config", { clear = true })

-- Re-apply Treesitter colors after base46 theme reload (not on every BufReadPost).
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  callback = function()
    theme.schedule_apply(50)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = augroup,
  pattern = "NvThemeReload",
  callback = function()
    theme.schedule_apply(50)
  end,
})

-- blink.cmp: hide stuck completion popups
local function blink_cmp_hide_if_open()
  pcall(function()
    local blink = require("blink.cmp")
    if blink.is_visible and blink.is_visible() then
      blink.hide()
    end
  end)
end

vim.api.nvim_create_autocmd("ModeChanged", {
  group = augroup,
  pattern = "i:*",
  callback = function()
    vim.schedule(blink_cmp_hide_if_open)
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
  group = augroup,
  callback = function()
    vim.schedule(blink_cmp_hide_if_open)
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = blink_cmp_hide_if_open,
})

-- Statusline clock (chadrc.lua statusline.modules.clock)
local clock_timer = vim.uv.new_timer()
clock_timer:start(60000, 60000, function()
  vim.schedule(function()
    if vim.fn.has("nvim-0.11") == 1 then
      pcall(vim.cmd.redrawstatus, { bang = true })
    else
      pcall(vim.cmd, "redrawstatus!")
    end
  end)
end)

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    if vim.hl and vim.hl.on_yank then
      vim.hl.on_yank()
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = augroup,
  callback = function(args)
    local bt = vim.bo[args.buf].buftype
    if bt == "" or bt == "acwrite" then
      vim.wo.number = true
      vim.wo.relativenumber = true
    end
  end,
})

-- C/C++: disable regex syntax (Treesitter only). NvChad already calls treesitter.start on FileType *.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "c", "cpp" },
  callback = function(args)
    local buf = args.buf
    vim.bo[buf].smartindent = false
    vim.bo[buf].cindent = true
    vim.bo[buf].syntax = ""
  end,
})

-- Assembly label navigation
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "asm", "nasm", "gas" },
  callback = function(args)
    local bufnr = args.buf
    local label_pattern = [[^\s*\(\x\+\s\+\)\?<[^>]\+>:\|^\h\w*:$]]

    vim.keymap.set("n", "]m", function()
      vim.fn.search(label_pattern, "W")
    end, { buffer = bufnr, desc = "Next asm label" })

    vim.keymap.set("n", "[m", function()
      vim.fn.search(label_pattern, "bW")
    end, { buffer = bufnr, desc = "Previous asm label" })

    vim.keymap.set("n", "<leader>al", function()
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local items = {}
      for i, line in ipairs(lines) do
        if line:match("^%s*%x+%s+<[^>]+>:$") or line:match("^%a[%w_]*:$") then
          table.insert(items, { bufnr = bufnr, lnum = i, col = 1, text = line })
        end
      end
      vim.fn.setqflist({}, " ", { title = "Assembly Labels", items = items })
      vim.cmd("copen")
    end, { buffer = bufnr, desc = "List asm labels in quickfix" })
  end,
})
