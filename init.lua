-- Neovim configuration entry point
-- Modular Lua-based configuration

-- Set leader keys BEFORE loading plugins
vim.g.mapleader = ","
vim.g.maplocalleader = "_"

-- Bootstrap lazy.nvim plugin manager
require("config.lazy")

-- Load core configurations
require("config.options")
require("config.keymaps")
require("config.autocmds")
