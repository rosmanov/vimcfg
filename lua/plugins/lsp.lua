-- LSP configuration

return {
  -- Native LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      -- Check Neovim version
      local nvim_11 = vim.fn.has("nvim-0.11") == 1

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- LSP keymaps (applied to all LSP clients)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf, silent = true }

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

          -- References in quickfix/location list (same window)
          vim.keymap.set("n", "gr", function()
            vim.lsp.buf.references(nil, {
              on_list = function(items)
                vim.fn.setqflist({}, ' ', items)
                vim.cmd('copen')
              end
            })
          end, opts)

          vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<F8>", vim.lsp.buf.format, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<space>d", vim.diagnostic.open_float, opts)
        end,
      })

      -- Language server configurations
      local servers = {
        intelephense = {
          settings = {
            intelephense = {
              files = {
                maxSize = 5000000,
                associations = { "*.php", "*.phtml", "*.inc" },
                exclude = {
                  "**/.git/**", "**/.svn/**", "**/.hg/**", "**/CVS/**",
                  "**/.DS_Store/**", "**/node_modules/**", "**/bower_components/**",
                  "**/.history/**",
                },
              },
              environment = { phpVersion = "8.2.15" },
              diagnostics = { enable = true },
            },
          },
        },
        gopls = {
          settings = {
            gopls = { staticcheck = true, gofumpt = true },
          },
        },
        pyright = {
          settings = {
            python = { analysis = { typeCheckingMode = "basic" } },
          },
        },
        ts_ls = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        jsonls = {},
        yamlls = {},
        clangd = {
          cmd = { "clangd", "--background-index", "--clang-tidy" },
        },
        kotlin_language_server = {},
        bashls = {},
      }

      -- Setup servers
      if nvim_11 then
        -- Use new vim.lsp.config API for nvim 0.11+
        for name, config in pairs(servers) do
          config.capabilities = capabilities
          vim.lsp.config[name] = config
          vim.lsp.enable(name)
        end
      else
        -- Fall back to lspconfig for older versions
        local lspconfig = require("lspconfig")
        for name, config in pairs(servers) do
          config.capabilities = capabilities
          lspconfig[name].setup(config)
        end
      end
    end,
  },

  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
