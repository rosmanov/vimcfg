-- Neovim options
local opt = vim.opt

-- General
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.hidden = true
opt.history = 1000
opt.updatetime = 300
opt.timeoutlen = 400

-- UI
opt.number = false
opt.signcolumn = "yes"
opt.showmode = false
opt.cmdheight = 2
opt.termguicolors = true
opt.cursorline = true
opt.scrolloff = 3
opt.sidescrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.listchars = { tab = "› ", trail = "•", extends = "#", nbsp = "." }

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.autoindent = true
opt.smartindent = true

-- Folding
opt.foldmethod = "indent"
opt.foldlevel = 99

-- Backup and undo
opt.backup = true
opt.backupdir = vim.fn.stdpath("data") .. "/backup"
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Create backup/undo directories if they don't exist
vim.fn.mkdir(vim.fn.stdpath("data") .. "/backup", "p")
vim.fn.mkdir(vim.fn.stdpath("data") .. "/undo", "p")

-- Disable providers we don't need
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Python provider - auto-detect or use local config
local function setup_python()
  -- Try to load local config
  local ok, local_config = pcall(require, "config.local")
  if ok and local_config.python3_host_prog then
    return local_config.python3_host_prog
  end

  -- Auto-detect Python from pyenv
  local pyenv_root = vim.fn.expand("~/.pyenv")
  if vim.fn.isdirectory(pyenv_root) == 1 then
    local pyenv_python = vim.fn.expand("~/.pyenv/shims/python3")
    if vim.fn.executable(pyenv_python) == 1 then
      return pyenv_python
    end
  end

  -- Fall back to system python3
  if vim.fn.executable("python3") == 1 then
    return vim.fn.exepath("python3")
  end

  return nil
end

local python_path = setup_python()
if python_path then
  vim.g.python3_host_prog = python_path
end
