-- Git plugins
return {
  -- Fugitive - Git commands
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gstatus", "Gdiff", "Gcommit", "Gblame" },
    keys = {
      { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
      { "<leader>gd", "<cmd>Gdiff<CR>", desc = "Git diff" },
      { "<leader>gc", "<cmd>Git commit<CR>", desc = "Git commit" },
      { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git blame" },
      { "<leader>gl", "<cmd>Git log<CR>", desc = "Git log" },
      { "<leader>gp", "<cmd>Git push<CR>", desc = "Git push" },
    },
  },

  -- GitHub integration
  {
    "tpope/vim-rhubarb",
    dependencies = "tpope/vim-fugitive",
    config = function()
      -- Load GitHub Enterprise URLs from local config
      local ok, local_config = pcall(require, "config.local")
      if ok and local_config.github_enterprise_urls then
        vim.g.github_enterprise_urls = local_config.github_enterprise_urls
      end
    end,
  },

  -- Bitbucket integration
  { "tommcdo/vim-fubitive", dependencies = "tpope/vim-fugitive" },

  -- Git signs in gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]h", gs.next_hunk, { desc = "Next git hunk" })
          map("n", "[h", gs.prev_hunk, { desc = "Previous git hunk" })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
        end,
      })
    end,
  },

  -- Git conflict markers navigation and resolution
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
    config = function()
      require("git-conflict").setup({
        default_mappings = true, -- ]x/[x to navigate, co/ct/cb/c0 to resolve
        disable_diagnostics = true, -- avoid LSP errors on conflict markers
      })

      -- Muted colors (tokyonight-inspired) for darkspectrum, which has
      -- very saturated Diff highlights that look "toxic" with defaults.
      local function set_conflict_highlights()
        vim.api.nvim_set_hl(0, "GitConflictCurrent", { bg = "#1c3829", fg = "#73daca" })
        vim.api.nvim_set_hl(0, "GitConflictCurrentLabel", { bg = "#1c3829", fg = "#73daca", bold = true })
        vim.api.nvim_set_hl(0, "GitConflictIncoming", { bg = "#1a2a4a", fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "GitConflictIncomingLabel", { bg = "#1a2a4a", fg = "#7aa2f7", bold = true })
        vim.api.nvim_set_hl(0, "GitConflictAncestor", { bg = "#2d1f3d", fg = "#bb9af7" })
        vim.api.nvim_set_hl(0, "GitConflictAncestorLabel", { bg = "#2d1f3d", fg = "#bb9af7", bold = true })
      end

      if vim.g.colors_name == "darkspectrum" then
        set_conflict_highlights()
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "darkspectrum",
        callback = set_conflict_highlights,
      })
    end,
  },

  -- Enhanced diff view
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Open diff view" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "File history" },
    },
  },
}
