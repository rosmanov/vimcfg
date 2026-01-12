-- Mason: portable package manager for LSP servers, linters, formatters
return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- Mason integration with LSP
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason-lspconfig").setup({
        -- Auto-install these LSP servers if not already installed
        ensure_installed = {
          "lua_ls",
          "bashls",
        },
        automatic_installation = false, -- Don't auto-install all servers
      })
    end,
  },

  -- Mason integration with nvim-lint
  {
    "rshkarin/mason-nvim-lint",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-lint" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason-nvim-lint").setup({
        -- Auto-install these linters if not already installed
        ensure_installed = {},
        automatic_installation = false,
      })
    end,
  },
}
