-- Autocommands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Restore cursor position
local restore_cursor = augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = restore_cursor,
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd('normal! g`"')
    end
  end,
})

-- Strip trailing whitespace on save
local strip_whitespace = augroup("StripWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = strip_whitespace,
  pattern = { "*.php", "*.js", "*.ts", "*.jsx", "*.tsx", "*.py", "*.lua", "*.go", "*.c", "*.cpp", "*.java" },
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Highlight on yank
local highlight_yank = augroup("HighlightYank", { clear = true })
autocmd("TextYankPost", {
  group = highlight_yank,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Git commit messages
local git_commit = augroup("GitCommit", { clear = true })
autocmd("FileType", {
  group = git_commit,
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.spell = true
    vim.cmd("normal! gg")
  end,
})

-- Auto-close location/quickfix list after selecting an item
local close_qf_list = augroup("CloseQfList", { clear = true })
autocmd("FileType", {
  group = close_qf_list,
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<CR>", function()
      -- Check if it's a location list or quickfix list
      local is_loclist = vim.fn.getloclist(0, { filewinid = 0 }).filewinid ~= 0
      local line = vim.fn.line(".")

      if is_loclist then
        -- Location list
        vim.cmd(".ll")
        vim.cmd("lclose")
      else
        -- Quickfix list
        vim.cmd(".cc")
        vim.cmd("cclose")
      end
    end, { buffer = true, silent = true })
  end,
})
