-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with plugin imports
require("lazy").setup({
  spec = {
    { import = "plugins.core" },
    { import = "plugins.ui" },
    { import = "plugins.editor" },
    { import = "plugins.lsp" },
    { import = "plugins.git" },
    { import = "plugins.tools" },
    { import = "plugins.languages.php" },
    { import = "plugins.languages.python" },
  },
  rocks = { enabled = false }, -- Disable luarocks (not needed)
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
})
