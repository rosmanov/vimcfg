-- Editor enhancement plugins
return {
  -- Surround operations (replaces vim-surround)
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        disable_filetype = { "TelescopePrompt" },
      })
    end,
  },

  -- Comments (replaces nerdcommenter)
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = true,
  },

  -- Todo comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },

  -- Multiple cursors
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
  },

  -- Fuzzy finder (replaces fzf/ack.vim)
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
              ["<C-d>"] = actions.delete_buffer, -- Delete buffer with Ctrl-d
            },
            n = {
              ["dd"] = actions.delete_buffer, -- Delete buffer with dd in normal mode
            },
          },
        },
        pickers = {
          buffers = {
            sort_lastused = true,
            sort_mru = true,
            theme = "dropdown",
            previewer = false,
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
        },
      })
      telescope.load_extension("fzf")
    end,
  },

  -- Tagbar alternative
  {
    "stevearc/aerial.nvim",
    keys = {
      { "<localleader>tt", "<cmd>AerialToggle<CR>", desc = "Toggle symbol outline" },
    },
    config = true,
  },
}
