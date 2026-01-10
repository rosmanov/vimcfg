-- PHP-specific plugins and configuration
return {
  -- PHP namespace management
  {
    "arnaud-lb/vim-php-namespace",
    ft = "php",
    keys = {
      { "<leader>u", "<cmd>call PhpInsertUse()<CR>", desc = "Insert PHP use statement", ft = "php" },
      { "<leader>e", "<cmd>call PhpExpandClass()<CR>", desc = "Expand PHP class", ft = "php" },
    },
  },

  -- PHP debugger
  {
    "puremourning/vimspector",
    ft = { "php", "python", "go" },
    config = function()
      vim.g.vimspector_enable_mappings = "HUMAN"
    end,
    keys = {
      { "<leader>vl", "<cmd>call vimspector#Launch()<CR>", desc = "Launch debugger" },
      { "<leader>vr", "<cmd>VimspectorReset<CR>", desc = "Reset debugger" },
      { "<leader>vc", "<cmd>call vimspector#Continue()<CR>", desc = "Continue" },
      { "<leader>vb", "<cmd>call vimspector#ToggleBreakpoint()<CR>", desc = "Toggle breakpoint" },
    },
  },

  -- PHP folding
  {
    "rayburgemeestre/phpfolding.vim",
    ft = "php",
  },
}
