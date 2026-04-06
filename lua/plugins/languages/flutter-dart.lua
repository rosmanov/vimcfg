-- lazy.nvim setup for Flutter <https://docs.flutter.dev>.
return {
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- Optional but recommended for better UI menus
    },
    config = function()
      require("flutter-tools").setup({
        ui = { border = "rounded" },
        closing_tags = { enabled = true }, -- Shows " // End of Column" comments
        lsp = {
          color_cmds = { enabled = true },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
          },
        },
        debugger = {
          enabled = true,
          run_via_dap = true, -- Requires nvim-dap
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    lazy = false,
  }
}
