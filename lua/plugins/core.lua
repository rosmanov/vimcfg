-- Core plugins
return {
  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local status_ok, configs = pcall(require, "nvim-treesitter.configs")
      if not status_ok then
        return
      end

      configs.setup({
        ensure_installed = {
          "lua", "vim", "vimdoc",
          "php", "phpdoc",
          "javascript", "typescript", "tsx",
          "python", "go", "c", "cpp",
          "json", "yaml", "toml",
          "html", "css",
          "bash", "markdown",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },

  -- Useful lua functions library
  { "nvim-lua/plenary.nvim" },

  -- Which-key for keybinding hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        plugins = { spelling = true },
        win = { border = "rounded" },
        delay = 500, -- Delay before showing which-key (don't interfere with gt)
      })
    end,
  },
}
