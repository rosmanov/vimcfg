# Neovim Lua Configuration - Development Guide

This is a modular, Lua-based Neovim configuration using lazy.nvim for plugin management. This guide helps Claude Code work effectively with this repository.

## Project Overview

**Type:** Personal Neovim configuration
**Plugin Manager:** lazy.nvim (auto-bootstrapped)
**Primary Language:** Lua
**Neovim Version:** 0.10+ (0.11+ optimized)
**Key Features:** LSP, completion, linting, formatting, debugging, Git integration, project-local configs

## Repository Structure

```
~/.config/nvim/
├── init.lua                    # Entry point - loads config modules
├── lua/
│   ├── config/                 # Core configuration modules
│   │   ├── lazy.lua           # Plugin manager bootstrap
│   │   ├── options.lua        # Neovim settings (vim.opt)
│   │   ├── keymaps.lua        # Global keybindings
│   │   ├── autocmds.lua       # Autocommands
│   │   ├── local.lua          # Machine-specific (gitignored, optional)
│   │   └── project-local.lua  # Project config loader helpers
│   └── plugins/               # Plugin specifications (lazy.nvim format)
│       ├── core.lua           # Treesitter, plenary, which-key
│       ├── ui.lua             # UI plugins (theme, statusline, tree)
│       ├── editor.lua         # Editor enhancements (telescope, surround)
│       ├── mason.lua          # LSP/linter/formatter installer
│       ├── lsp.lua            # LSP setup and completion (nvim-cmp)
│       ├── linting.lua        # nvim-lint + conform.nvim
│       ├── git.lua            # Git integration
│       ├── tools.lua          # Copilot, DAP
│       └── languages/         # Language-specific plugins
│           ├── php.lua
│           └── python.lua
├── after/ftplugin/            # Filetype-specific settings
├── colors/                    # Custom colorschemes
├── .stylua.toml              # Lua formatting config
└── README.md                 # User documentation
```

## Key Conventions & Patterns

### Module Organization

1. **Config modules** (`lua/config/*.lua`): Core Neovim configuration
2. **Plugin specs** (`lua/plugins/*.lua`): Return tables for lazy.nvim
3. **Filetype configs** (`after/ftplugin/{ft}.lua`): Filetype-specific settings
4. **Local overrides** (`lua/config/local.lua`): Machine-specific (gitignored)

### Coding Style

- **Indentation:** 2 spaces (configured in .stylua.toml)
- **Formatter:** StyLua
- **Line length:** 120 characters (stylua config)
- **File naming:** snake_case for Lua files
- **Variable naming:** snake_case (Lua convention)

### Plugin Management Patterns

**Standard plugin spec structure:**
```lua
return {
  "author/plugin-name",
  dependencies = { "required/plugin" },
  event = "BufReadPost",  -- or cmd/keys/ft for lazy-loading
  opts = {},  -- passed to setup() automatically
  config = function()
    -- Custom setup code
    require("plugin").setup({})
  end,
}
```

**Lazy-loading triggers:**
- `event`: Use for UI/editor plugins (BufReadPost, VeryLazy, InsertEnter)
- `cmd`: Use for command-triggered plugins (`:Telescope`, `:Mason`)
- `keys`: Use for keybinding-triggered plugins
- `ft`: Use for language-specific plugins (php, python, etc.)

**Safe configuration pattern:**
```lua
config = function()
  local ok, plugin = pcall(require, "plugin-name")
  if not ok then
    return
  end
  plugin.setup({ ... })
end
```

### Keybinding Patterns

**Global keybindings** (in `lua/config/keymaps.lua`):
```lua
local map = vim.keymap.set
local opts = { noremap = true, silent = true, desc = "Description" }
map("n", "<leader>key", "<cmd>Command<CR>", opts)
```

**LSP keybindings** (auto-attached via LspAttach autocmd in `lua/plugins/lsp.lua`):
```lua
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = desc })
    end
    -- Define keybindings here
  end,
})
```

**Leader keys:**
- Leader: `,` (comma)
- Local leader: `_` (underscore)

### Autocommand Patterns

**Standard structure:**
```lua
local augroup = vim.api.nvim_create_augroup("GroupName", { clear = true })
vim.api.nvim_create_autocmd({"Event1", "Event2"}, {
  group = augroup,
  pattern = {"*.ext"},
  callback = function()
    -- Action
  end,
})
```

### LSP Configuration

**Neovim 0.11+ version-aware:**
- Uses new `vim.lsp.config` API on 0.11+
- Falls back to `lspconfig` on older versions
- Check version: `if vim.fn.has("nvim-0.11") == 1`

**Adding a new LSP server:**
1. Add to auto-install list in `lua/plugins/mason.lua`
2. Add configuration in `lua/plugins/lsp.lua`
3. Use version-aware setup (see existing servers as templates)

**LSP servers configured:**
- PHP: intelephense (custom file size limits, exclusions)
- Go: gopls (staticcheck, gofumpt)
- Python: pyright
- TypeScript/JS: ts_ls
- Lua: lua_ls (vim global recognized)
- Bash: bashls
- C/C++: clangd
- JSON/YAML: jsonls, yamlls
- Kotlin: kotlin_language_server
- XML: lemminx (custom format settings)

### Linting & Formatting

**Linting:** nvim-lint (in `lua/plugins/linting.lua`)
- Auto-triggers: BufEnter, BufWritePost, InsertLeave
- Add linters in `linters_by_ft` table
- Project-local overrides supported

**Formatting:** conform.nvim (in `lua/plugins/linting.lua`)
- Format on save (toggleable via `:FormatToggle`)
- Add formatters in `formatters_by_ft` table
- Project-local overrides supported

**Project-local configuration:**
Create `.nvim.lua` in project root:
```lua
return {
  linters = { python = { "ruff" } },
  formatters = { python = { "ruff_format" } },
}
```

## Development Workflow

### Adding a New Plugin

1. **Determine category:** core, ui, editor, lsp, tools, or language-specific
2. **Create/edit plugin file:** `lua/plugins/{category}.lua`
3. **Add plugin spec:**
   ```lua
   {
     "author/plugin-name",
     event = "BufReadPost",  -- Choose appropriate trigger
     opts = {},
     config = function()
       require("plugin-name").setup({})
     end,
   }
   ```
4. **Restart Neovim** or run `:Lazy sync` to install
5. **Test the plugin** and verify it loads correctly
6. **Document keybindings** in README.md if applicable

### Modifying Configuration

**Change Neovim settings:**
- Edit `lua/config/options.lua`
- Use `vim.opt.setting_name = value` pattern

**Add global keybindings:**
- Edit `lua/config/keymaps.lua`
- Use consistent pattern with leader key

**Add autocommands:**
- Edit `lua/config/autocmds.lua`
- Use augroups for organization

**Language-specific settings:**
- Create/edit `after/ftplugin/{filetype}.lua`
- Settings auto-apply when opening that filetype

### Adding Language Support

1. **LSP Server:**
   - Add to `ensure_installed` in `lua/plugins/mason.lua`
   - Configure in `lua/plugins/lsp.lua` (use version-aware pattern)

2. **Linter:**
   - Add to `linters_by_ft` in `lua/plugins/linting.lua`
   - Install via Mason or system package manager

3. **Formatter:**
   - Add to `formatters_by_ft` in `lua/plugins/linting.lua`
   - Install via Mason or system package manager

4. **Language-specific plugins:**
   - Create `lua/plugins/languages/{language}.lua` if substantial
   - Add to existing plugin file if minimal

5. **Filetype settings:**
   - Create `after/ftplugin/{filetype}.lua` for indentation, etc.

### Testing Changes

**After making changes:**
1. **Reload config:** `:source %` (if editing current file) or restart Neovim
2. **Check for errors:** `:messages` or `:checkhealth`
3. **Verify plugins loaded:** `:Lazy` (check status)
4. **Test LSP:** Open a file, `:LspInfo` to verify attachment
5. **Test keybindings:** Use `<leader>` and wait for which-key hints

**Troubleshooting:**
- `:Lazy check` - verify plugin installation
- `:Mason` - check LSP/linter/formatter installation
- `:LspInfo` - check LSP server status
- `:checkhealth` - comprehensive health check
- `:messages` - view error messages

## Machine-Specific Configuration

**Create `lua/config/local.lua` for:**
- Custom colorscheme preference
- Machine-specific paths
- Personal keybindings
- Environment-specific settings

**Example:**
```lua
local M = {}
M.colorscheme = "kanagawa"
M.custom_setting = "value"
return M
```

**Usage in other files:**
```lua
local ok, local_config = pcall(require, "config.local")
local colorscheme = (ok and local_config.colorscheme) or "tokyonight"
```

## Important Files

### Critical Files (Do Not Delete)

- `init.lua` - Entry point, must exist
- `lua/config/lazy.lua` - Plugin manager bootstrap
- `lua/config/options.lua` - Core Neovim settings
- `lua/plugins/*.lua` - Plugin specifications
- `.stylua.toml` - Lua formatting configuration

### Generated Files (Git-Ignored)

- `lua/config/local.lua` - Machine-specific config
- `lazy-lock.json` - Plugin version lock file (auto-generated)
- `.nvimlog` - Neovim logs

### Documentation Files

- `README.md` - User-facing documentation (keybindings, installation, troubleshooting)
- `CLAUDE.md` - This file (development guide)

## Git Workflow

**Commit guidelines:**
- Descriptive commit messages
- Use conventional commits format preferred (e.g., "feat:", "fix:", "docs:")
- Test changes before committing
- Review `.gitignore` before adding new files

**Ignored files:**
- `lua/config/local.lua` (machine-specific)
- `lazy-lock.json` (auto-generated)
- `.nvimlog` (logs)
- `*.swp`, `.DS_Store` (temporary)

**Branch:** Currently on `master` (main branch)

## Common Tasks

### Update All Plugins
```
:Lazy sync
```

### Update LSP Servers/Linters/Formatters
```
:Mason
```
Press `U` to update all installed packages.

### Format Lua Code
Uses StyLua (configured in `.stylua.toml`):
```bash
stylua .
```

### View LSP Server Logs
```
:LspLog
```

### Toggle Format-on-Save
```
:FormatToggle
```

### View Installed Plugins
```
:Lazy
```

## Debugging

**LSP not working:**
1. `:LspInfo` - check if server attached
2. `:Mason` - verify server installed
3. `:LspLog` - check server logs
4. Restart LSP: `:LspRestart`

**Plugin not loading:**
1. `:Lazy` - check plugin status
2. Verify lazy-loading trigger (event/cmd/keys/ft)
3. `:messages` - look for error messages
4. Try `:Lazy reload {plugin-name}`

**Keybinding not working:**
1. Press `<leader>` and wait for which-key popup
2. `:verbose map <key>` - check what's mapped
3. Verify keybinding definition in `keymaps.lua`

**Configuration error:**
1. `:messages` - view error messages
2. `:checkhealth` - run health checks
3. Check syntax in modified Lua files
4. Restart Neovim with `nvim --clean` to test without config

## Best Practices for Claude Code

**When modifying this config:**

1. **Always read before editing** - Use Read tool to understand existing patterns
2. **Follow existing conventions** - Match the code style and patterns already in place
3. **Use version-aware LSP setup** - Check Neovim version before using new APIs
4. **Test after changes** - Verify the configuration still works
5. **Preserve lazy-loading** - Don't remove event/cmd/keys/ft triggers without reason
6. **Document keybindings** - Add new keybindings to README.md
7. **Use pcall for safety** - Wrap plugin requires in pcall() for graceful errors
8. **Respect .gitignore** - Don't commit local.lua or lazy-lock.json
9. **Update README** - Keep user documentation in sync with changes
10. **Format Lua code** - Use StyLua formatting (2 spaces, 120 char width)

**When adding features:**
- Prefer existing plugins over adding new ones
- Use lazy-loading to keep startup fast
- Consider machine-specific needs (use local.lua pattern)
- Add project-local support when relevant (linters, formatters)
- Test on both Neovim 0.10 and 0.11+ if modifying LSP code

**File modification priority:**
1. Read existing file completely
2. Understand the pattern and structure
3. Make minimal changes
4. Preserve formatting and style
5. Test the changes

**Communication:**
- Reference files with `filepath:line_number` format
- Be concise in explanations
- Provide context for why changes are needed
- Offer alternatives when multiple approaches exist
