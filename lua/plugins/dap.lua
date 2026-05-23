return {
  -- Blindagem: impede Lazy de tentar require("dap").setup(...)
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      dap.listeners.after.event_initialized["dapui_lazy_load"] = function()
        require("lazy").load({ plugins = { "nvim-dap-ui", "nvim-dap-virtual-text" } })
        pcall(function()
          require("dapui").open()
        end)
      end

      dap.listeners.before.event_terminated["dapui_lazy_load"] = function()
        pcall(function()
          require("dapui").close()
        end)
      end
      dap.listeners.before.event_exited["dapui_lazy_load"] = function()
        pcall(function()
          require("dapui").close()
        end)
      end
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dapui = require("dapui")

      dapui.setup()
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
    opts = {},
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-python").setup("python")
    end,
  },
}
