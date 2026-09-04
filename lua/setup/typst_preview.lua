--- Live Typst preview in the browser (typst-preview.nvim + tinymist).
--- Space mp on a .typ buffer; markdown/PlantUML still use markdown_preview.lua.
local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("typst_commentstring", { clear = true }),
    pattern = "typst",
    callback = function()
      vim.bo.commentstring = "// %s"
    end,
  })

  local ok, preview = pcall(require, "typst-preview")
  if not ok then
    return
  end

  local deps = { tinymist = "tinymist" }
  if vim.fn.executable("websocat") == 1 then
    deps.websocat = "websocat"
  end

  preview.setup({
    follow_cursor = true,
    invert_colors = "never",
    dependencies_bin = deps,
    get_root = function(path)
      local env = os.getenv("TYPST_ROOT")
      if env and env ~= "" then
        return env
      end
      local dir = vim.fs.dirname(vim.fn.fnamemodify(path, ":p"))
      local marker = vim.fs.find({ "typst.toml", "cv.typ", ".git" }, {
        path = dir,
        upward = true,
        limit = 1,
      })
      if marker[1] then
        return vim.fs.dirname(marker[1])
      end
      return dir
    end,
    get_main_file = function(path)
      local dir = vim.fn.fnamemodify(path, ":p:h")
      local cv = vim.fs.find("cv.typ", { path = dir, upward = true, type = "file", limit = 1 })
      if cv[1] then
        return cv[1]
      end
      return path
    end,
  })
end

function M.toggle()
  if vim.bo.filetype ~= "typst" then
    vim.notify("Open a .typ file, then Space mp", vim.log.levels.WARN)
    return
  end
  vim.cmd.packadd("typst-preview.nvim")
  if vim.fn.exists(":TypstPreviewToggle") ~= 2 then
    vim.notify("typst-preview.nvim missing — restart nvim or :lua vim.pack.update()", vim.log.levels.ERROR)
    return
  end
  vim.cmd("TypstPreviewToggle")
end

return M
