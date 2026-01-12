# Neovim Configuration

My Neovim configuration.

## Features

- Native LSP with nvim-lspconfig (PHP via intelephense, Go, Python, TypeScript, etc.)
- **Linting with nvim-lint** (phpmd, phpcs, phpstan, eslint, etc.)
- **Formatting with conform.nvim** (phpcbf, prettier, stylua)
- **Project-specific linter/formatter configuration**
- Lazy.nvim plugin manager
- Telescope fuzzy finder
- nvim-tree file explorer
- Modern UI with lualine, bufferline
- Git integration (fugitive, gitsigns)
- Treesitter syntax highlighting
- nvim-cmp completion
- Copilot support

## Installation

### Prerequisites

**All platforms:**
```bash
# Neovim 0.11+
brew install neovim  # macOS
# or apt install neovim, etc.
```

**Language servers:**
```bash
# PHP (intelephense)
npm install -g intelephense

# Go
go install golang.org/x/tools/gopls@latest

# Python
pip install pyright

# TypeScript/JavaScript
npm install -g typescript-language-server typescript

# Lua
brew install lua-language-server  # or platform equivalent

# JSON/YAML
npm install -g vscode-langservers-extracted

# Bash
npm install -g bash-language-server
```

**Linters and formatters (optional but recommended):**
```bash
# PHP linters
composer global require phpmd/phpmd
composer global require squizlabs/php_codesniffer
composer global require phpstan/phpstan

# JavaScript/TypeScript
npm install -g eslint prettier

# Lua
brew install stylua  # or cargo install stylua
```

### Setup

1. **Clone or copy this config:**
   ```bash
   # If using git
   git clone <your-repo> ~/.config/nvim

   # Or just copy the directory
   cp -r /path/to/nvim ~/.config/nvim
   ```

2. **Set up intelephense premium license (optional):**
   ```bash
   mkdir -p ~/.config/intelephense
   echo "YOUR_LICENSE_KEY" > ~/.config/intelephense/licence.txt
   ```

3. **Launch Neovim:**
   ```bash
   nvim
   ```
   Plugins will auto-install on first launch.

4. **Install treesitter parsers:**
   ```vim
   :TSInstall php lua python go javascript typescript
   ```

## Machine-Specific Configuration

For settings that differ between machines (Python paths, project-specific linters, etc.), create:

```bash
~/.config/nvim/lua/config/local.lua
```

Example:
```lua
return {
  -- Override Python path if auto-detection doesn't work
  python3_host_prog = "/usr/local/bin/python3",

  -- Project-specific configurations
  projects = {
    ["~/projects/myproject"] = {
      -- Linters by filetype for this project
      linters_by_ft = {
        php = { "php", "phpmd", "phpcs", "phpstan" },
        javascript = { "eslint" },
      },

      -- Custom linter configurations
      custom_linters = {
        phpcs = {
          cmd = vim.fn.expand("~/projects/myproject/vendor/bin/phpcs"),
          args = {
            "--standard=" .. vim.fn.expand("~/projects/myproject/phpcs.xml"),
            "--report=json",
          },
        },
        eslint = {
          cmd = vim.fn.expand("~/projects/myproject/node_modules/.bin/eslint"),
        },
      },

      -- Formatters by filetype
      formatters_by_ft = {
        php = { "phpcbf" },
        javascript = { "prettier" },
      },

      -- Custom formatter configurations
      custom_formatters = {
        phpcbf = {
          command = vim.fn.expand("~/projects/myproject/vendor/bin/phpcbf"),
          args = { "--standard=PSR12", "-" },
          stdin = true,
        },
      },
    },
  },

  -- LSP server overrides
  lsp_servers = {
    intelephense = {
      settings = {
        intelephense = {
          environment = { phpVersion = "8.2.15" },
        },
      },
    },
  },
}
```

This file is gitignored and won't be synced.

**How project-specific configs work:**
- When you open a file in `~/projects/myproject`, the config automatically detects it
- Project-specific linters and formatters are used instead of defaults
- All user-specific paths stay in `local.lua` (not committed to git)

## Platform Differences

The config auto-detects Python:
1. Tries `~/.pyenv/shims/python3` (if pyenv exists)
2. Falls back to system `python3`
3. Can be overridden in `local.lua`

All other settings work identically on macOS and Linux.

## Key Bindings

### General
- `,` - Leader key
- `_` - Local leader
- `jk` - Exit insert mode
- `,/` - Toggle search highlight

### File Navigation
- `<C-e>` - Toggle file tree
- `,e` - Reveal current file in tree
- `,ff` - Find files (Telescope)
- `,fg` - Live grep
- `,b` or `,,` - Buffer picker
- `<S-H>` / `<S-L>` - Previous/next buffer

### LSP
- `gd` - Go to definition
- `gr` - Find references
- `K` - Hover documentation
- `,rn` - Rename symbol
- `,ca` - Code actions
- `<F8>` - Format code (LSP)
- `[d` / `]d` - Previous/next diagnostic
- `<C-p>` - Search symbols (workspace)

### Linting & Formatting
- `:Lint` - Manually trigger linting
- `:Format` - Manually format current buffer
- `:FormatToggle` - Toggle format-on-save
- Format on save is enabled by default

### Git
- `,gs` - Git status
- `,gd` - Git diff
- `,gc` - Git commit
- `,gb` - Git blame
- `]h` / `[h` - Next/previous git hunk

### Tabs
- `gt` / `gT` - Next/previous tab
- `,tn` - New tab
- `,tc` - Close tab

## Troubleshooting

### Check health
```vim
:checkhealth
```

### Check LSP status
```vim
:LspInfo
```

### Update plugins
```vim
:Lazy update
```

### Python provider issues
Check detected path:
```vim
:echo g:python3_host_prog
```

Override in `lua/config/local.lua` if needed.

### Linting not working
1. Check if linters are installed:
   ```bash
   which phpcs phpstan phpmd eslint
   ```

2. Verify project config is loaded:
   ```vim
   :lua print(vim.inspect(require("config.project-local").load_project_config()))
   ```

3. Check linter configuration:
   ```vim
   :lua print(vim.inspect(require("lint").linters_by_ft))
   ```

4. Check for errors:
   ```vim
   :messages
   ```

5. Test linter manually:
   ```vim
   :Lint
   ```
