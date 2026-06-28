-- Digital clock + date for NvUI statusline (see chadrc.lua modules.clock)
local M = {}

local timer
local hl_set = false

local function separator_left()
  local config = require("nvconfig").ui.statusline
  local utils = require("nvchad.stl.utils")
  local sep_style = config.separator_style
  local icons = utils.separators
  local sep = type(sep_style) == "table" and sep_style or icons[sep_style]
  return sep.left
end

local function ensure_highlights()
  if hl_set or vim.fn.filereadable(vim.g.base46_cache .. "colors") ~= 1 then
    return
  end

  local ok, colors = pcall(dofile, vim.g.base46_cache .. "colors")
  if not ok or not colors then
    return
  end

  local bg = colors.statusline_bg or colors.black
  vim.api.nvim_set_hl(0, "St_clock_sep", { fg = colors.grey_fg or colors.grey, bg = bg })
  vim.api.nvim_set_hl(0, "St_clock_icon", { fg = colors.yellow or colors.cyan, bg = bg })
  vim.api.nvim_set_hl(0, "St_clock_time", { fg = colors.white, bg = bg, bold = true })
  vim.api.nvim_set_hl(0, "St_clock_text", { fg = colors.lightgrey or colors.grey_fg, bg = bg })
  hl_set = true
end

function M.statusline()
  ensure_highlights()

  local time = os.date("%H:%M:%S")
  local date = os.date("%a · %d %b %Y")
  local sep = separator_left()
  local narrow = vim.o.columns < 100

  if narrow then
    return table.concat({
      "%#St_clock_sep#",
      sep,
      "%#St_clock_icon#",
      "󰥔 ",
      "%#St_clock_time#",
      time,
      " ",
    })
  end

  return table.concat({
    "%#St_clock_sep#",
    sep,
    "%#St_clock_icon#",
    "󰥔 ",
    "%#St_clock_time#",
    time,
    "%#St_clock_text#",
    "  ",
    date,
    " ",
  })
end

function M.setup()
  ensure_highlights()

  if timer then
    return
  end

  timer = vim.uv.new_timer()
  timer:start(1000, 1000, vim.schedule_wrap(function()
    pcall(vim.cmd.redrawstatus)
  end))

  vim.api.nvim_create_autocmd("VimLeavePre", {
    once = true,
    callback = function()
      if timer then
        timer:stop()
        timer:close()
        timer = nil
      end
    end,
  })
end

return M
