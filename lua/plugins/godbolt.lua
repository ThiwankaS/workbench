return {
  {
    -- Compiler Explorer integration for C/C++ assembly inspection.
    "p00f/godbolt.nvim",
    cmd = { "Godbolt", "GodboltCompiler", "GodboltRun", "GodboltOpen" },
    config = function()
      require("godbolt").setup({
        -- Keep response files for troubleshooting and show compiler errors in quickfix.
        auto_cleanup = false,
        quickfix = { enable = true, auto_open = true },
        languages = {
          -- Use a valid current Compiler Explorer ID (clang170 was invalid).
          cpp = { compiler = "clang1701", options = { "-O2", "-std=c++20" } },
        },
      })

      -- Compatibility patch:
      -- Some godbolt.nvim versions construct the compile URL with quoted compiler IDs,
      -- which can return non-JSON responses and break vim.json.decode.
      -- Override only the request builder, keep the rest of plugin behavior untouched.
      local cmd = require("godbolt.cmd")
      cmd["build-cmd"] = function(compiler, text, options, exec_asm)
        local json = vim.json.encode({ source = text, options = options })
        local config = require("godbolt").config
        local req = string.format("godbolt_request_%s.json", exec_asm)
        local res = string.format("godbolt_response_%s.json", exec_asm)
        local file = io.open(req, "w")
        if file then
          file:write(json)
          io.close(file)
        end
        return string.format(
          'curl %s/api/compiler/%s/compile --data-binary @%s --header "Accept: application/json" --header "Content-Type: application/json" --output %s',
          config.url,
          compiler,
          req,
          res
        )
      end
    end,
  },
}
