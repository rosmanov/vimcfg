-- Python-specific plugins and configuration
return {
  -- Virtual environment selector
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
    },
    ft = "python",
    opts = {
      name = { "venv", ".venv", "env", ".env" },
    },
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<CR>", desc = "Select Python venv", ft = "python" },
      { "<leader>vc", "<cmd>VenvSelectCached<CR>", desc = "Select cached venv", ft = "python" },
    },
  },

  -- Python debugging (DAP configuration)
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      -- Auto-detect Python from current venv or system
      local python_path = vim.fn.exepath("python3")
      if vim.env.VIRTUAL_ENV then
        python_path = vim.env.VIRTUAL_ENV .. "/bin/python"
      end
      require("dap-python").setup(python_path)

      -- Python-specific debug keymaps
      vim.keymap.set("n", "<leader>dpr", function()
        require("dap-python").test_method()
      end, { desc = "Debug Python test method" })
    end,
  },

  -- Better indentation for Python
  {
    "Vimjas/vim-python-pep8-indent",
    ft = "python",
  },
}
