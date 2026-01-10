-- Keymaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better escape
map("i", "jk", "<ESC>", opts)

-- Search highlighting toggle
map("n", "<leader>/", ":set invhlsearch<CR>", opts)

-- Visual mode indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Buffer navigation
map("n", "<S-L>", ":bnext<CR>", opts)
map("n", "<S-H>", ":bprevious<CR>", opts)

-- Tab navigation - use explicit commands to avoid conflicts
map("n", "gt", "<cmd>tabnext<CR>", opts)
map("n", "gT", "<cmd>tabprevious<CR>", opts)
map("n", "<leader>tn", "<cmd>tabnew<CR>", opts)
map("n", "<leader>tc", "<cmd>tabclose<CR>", opts)

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Window resizing
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Clipboard operations
map("v", "<leader>y", '"+y', opts)
map("n", "<leader>Y", '"+yg_', opts)
map("n", "<leader>y", '"+y', opts)
map("n", "<leader>yy", '"+yy', opts)
map("n", "<leader>p", '"+p', opts)
map("n", "<leader>P", '"+P', opts)
map("v", "<leader>p", '"+p', opts)
map("v", "<leader>P", '"+P', opts)

-- Copy current file path
map("n", "<localleader>cp", ':let @+ = expand("%")<CR>', opts)

-- Quick save/quit
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)

-- Buffer management (modern BufExplorer replacement)
map("n", "<leader>b", "<cmd>Telescope buffers<CR>", opts)
map("n", "<leader><leader>", "<cmd>Telescope buffers<CR>", opts)

-- Fuzzy search everything (like IntelliJ Shift-Shift)
map("n", "<leader>fs", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts) -- All symbols in project
map("n", "<leader>fo", "<cmd>Telescope lsp_document_symbols<CR>", opts) -- Symbols in current file
map("n", "<C-p>", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts) -- Quick access

-- Location/Quickfix list
map("n", "<leader>cl", "<cmd>lopen<CR>", opts) -- Reopen location list
map("n", "<leader>cq", "<cmd>copen<CR>", opts) -- Reopen quickfix list

-- Clear search highlighting
map("n", "<Esc>", ":noh<CR>", opts)
