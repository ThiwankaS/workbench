return {
  {
    -- Compiler Explorer integration for C/C++ assembly inspection.
    "p00f/godbolt.nvim",
    cmd = { "Godbolt", "GodboltCompiler", "GodboltRun", "GodboltOpen" },
    config = function()
      require("godbolt").setup({
        languages = {
          cpp = { compiler = "clang170", options = { "-O2", "-std=c++20" } },
        },
      })
    end,
  },
}
