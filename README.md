# Neovim Configuration

My Neovim configuration.

## Features

- Native LSP with nvim-lspconfig (PHP via intelephense, Go, Python, etc.)
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

For settings that differ between machines (Python paths, etc.), create:

```bash
~/.config/nvim/lua/config/local.lua
```

Example:
```lua
return {
  -- Override Python path if auto-detection doesn't work
  python3_host_prog = "/usr/local/bin/python3",

  -- Add other machine-specific settings
}
```

This file is gitignored and won't be synced.

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
- `<F8>` - Format code
- `[d` / `]d` - Previous/next diagnostic
- `<C-p>` - Search symbols (workspace)

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
