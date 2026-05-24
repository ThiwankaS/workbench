return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP toggle breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Condition: "))
        end,
        desc = "DAP conditional breakpoint",
      },
      { "<leader>dc", function() require("dap").continue() end, desc = "DAP continue" },
      { "<leader>dC", function() require("dap").terminate() end, desc = "DAP terminate" },
      { "<leader>do", function() require("dap").step_over() end, desc = "DAP step over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "DAP step into" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "DAP step out" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "DAP run last" },
    },
    config = function()
      local signs = {
        DapBreakpoint = { text = "●", texthl = "DiagnosticSignError", linehl = "", numhl = "" },
        DapBreakpointRejected = { text = "◌", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" },
        DapStopped = { text = "→", texthl = "DiagnosticSignInfo", linehl = "Visual", numhl = "" },
      }
      for name, opts in pairs(signs) do
        if vim.sign and vim.sign.define then
          vim.sign.define(name, opts)
        else
          vim.fn.sign_define(name, opts)
        end
      end
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mason-org/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      automatic_installation = true,
      ensure_installed = { "codelldb" },
      handlers = {},
    },
    config = function(_, opts)
      require("mason-nvim-dap").setup(opts)
      local dap = require("dap")

      dap.configurations.cpp = {
        {
          type = "codelldb",
          request = "launch",
          name = "Launch file (prompt for binary)",
          cwd = "${workspaceFolder}",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          stopOnEntry = false,
          args = function()
            local a = vim.fn.input("Program args: ")
            return a ~= "" and vim.split(a, "%s+", { trimempty = true }) or {}
          end,
        },
        {
          type = "codelldb",
          request = "attach",
          name = "Attach to PID",
          cwd = "${workspaceFolder}",
          processId = function()
            local v = tonumber(vim.fn.input("PID: "), 10)
            return v -- nil cancels attach in most adapters
          end,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle({})
        end,
        desc = "Toggle DAP UI",
      },
    },
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup(opts or {})

      dap.listeners.before.attach.dapui_config = function()
        dapui.open({})
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close({})
      end
    end,
  },
}
