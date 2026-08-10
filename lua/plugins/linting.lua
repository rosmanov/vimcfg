-- Linting configuration with nvim-lint
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    config = function()
      local lint = require("lint")
      local project_local = require("config.project-local")

      -- Load global local configuration
      local ok, local_config = pcall(require, "config.local")
      local lint_config = (ok and local_config.linters) or {}

      -- Load project-specific configuration (checking helpers first, then global variables)
      local project_linters_by_ft = project_local.get_linters_by_ft() or vim.g.project_linters_by_ft
      local project_custom_linters = project_local.get_custom_linters() or vim.g.project_custom_linters

      -- Set linters by filetype (project config takes precedence)
      lint.linters_by_ft = project_linters_by_ft
        or lint_config.linters_by_ft
        or {
          php = { "php" },
          javascript = { "eslint" },
          typescript = { "eslint" },
          typescriptreact = { "eslint" },
          sh = { "shellcheck" },
        }

      -- Apply custom linter configurations (merge global and project configs)
      local custom_linters = vim.tbl_extend("force", lint_config.custom_linters or {}, project_custom_linters or {})

      for linter_name, config in pairs(custom_linters) do
        if lint.linters[linter_name] then
          for key, value in pairs(config) do
            lint.linters[linter_name][key] = value
          end
        end
      end

      -- Auto-lint on these events
      local lint_augroup = vim.api.nvim_create_augroup("nvim_lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          -- Only lint if the buffer is associated with a file
          if vim.api.nvim_buf_get_name(0) ~= "" then
            lint.try_lint()
          end
        end,
      })

      -- Manual lint command
      vim.api.nvim_create_user_command("Lint", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },

  -- Formatting with conform.nvim
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      local conform = require("conform")
      local project_local = require("config.project-local")

      -- Load global local configuration
      local ok, local_config = pcall(require, "config.local")
      local format_config = (ok and local_config.formatters) or {}

      -- Load project-specific configuration (checking helpers first, then global variables)
      local project_formatters_by_ft = project_local.get_formatters_by_ft() or vim.g.project_formatters_by_ft
      local project_custom_formatters = project_local.get_custom_formatters() or vim.g.project_custom_formatters

      conform.setup({
        formatters_by_ft = project_formatters_by_ft or format_config.formatters_by_ft or {
          c = { "clang_format" },
          cpp = { "clang_format" },
          lua = { "stylua" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
        },

        -- Custom formatters (merge global and project configs)
        formatters = vim.tbl_extend("force", format_config.custom_formatters or {}, project_custom_formatters or {}),

        -- Format on save (can be disabled)
        format_on_save = function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 3000, lsp_fallback = false }
        end,
      })

      -- Manual format command
      vim.api.nvim_create_user_command("Format", function(opts)
        conform.format({
          timeout_ms = 3000,
          lsp_fallback = false,
          range = {
            start = { opts.line1, 0 },
            ["end"] = { opts.line2, 0 },
          },
        })
      end, {
        desc = "Format selected range",
        range = true,
      })
    end,
  },
}
