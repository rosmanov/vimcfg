-- Development tools
return {
  -- GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = false, -- Manual trigger only
          keymap = {
            accept = "<C-J>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = { enabled = false },
      })

      -- Manual trigger keybinding
      vim.keymap.set("i", "<C-\\>", function()
        require("copilot.suggestion").next()
      end, { desc = "Trigger Copilot suggestion" })
    end,
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", desc = "Toggle breakpoint" },
      { "<leader>dc", "<cmd>lua require('dap').continue()<CR>", desc = "Continue" },
      { "<leader>di", "<cmd>lua require('dap').step_into()<CR>", desc = "Step into" },
      { "<leader>do", "<cmd>lua require('dap').step_over()<CR>", desc = "Step over" },
      { "<leader>du", "<cmd>lua require('dapui').toggle()<CR>", desc = "Toggle DAP UI" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup()

      -- Auto-open DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
