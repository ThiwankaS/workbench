require("nvchad.autocmds")

local augroup = vim.api.nvim_create_augroup("user_config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "c", "cpp" },
  callback = function(args)
    local buf = args.buf
    local lang = vim.bo[buf].filetype == "c" and "c" or "cpp"
    vim.schedule(function()
      if pcall(vim.treesitter.start, buf, lang) then
        -- Regex syntax stacks with TS; turning it off makes :Inspect show @ captures.
        vim.bo[buf].syntax = ""
      end
    end)
  end,
})

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
