-- UI plugins
return {
	-- Icon support (preferred by many modern plugins)
	{
		"echasnovski/mini.icons",
		config = function()
			require("mini.icons").setup()
		end,
	},

	-- File explorer (replaces NERDTree)
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<C-e>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
			{ "<leader>e", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal file in explorer" },
		},
		config = function()
			-- Disable netrw (recommended by nvim-tree)
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			require("nvim-tree").setup({
				sync_root_with_cwd = true,
				respect_buf_cwd = true,
				update_focused_file = {
					enable = true,
					update_root = true, -- Update root to current file's directory
				},
				view = {
					width = 30,
				},
				renderer = {
					group_empty = true,
					icons = {
						show = {
							git = true,
							folder = true,
							file = true,
							folder_arrow = true,
						},
					},
				},
				filters = {
					dotfiles = false,
				},
				git = {
					enable = true,
					ignore = false,
				},
			})
		end,
	},

	-- Status line (replaces vim-airline)
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					component_separators = { left = "|", right = "|" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	-- Buffer line
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		event = "VeryLazy",
		config = function()
			require("bufferline").setup({
				options = {
					diagnostics = "coc",
					separator_style = "slant",
					show_buffer_close_icons = false,
					show_close_icon = false,
				},
			})
		end,
	},

	-- Indent guides (replaces vim-indent-guides)
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("ibl").setup({
				indent = { char = "│" },
				scope = { enabled = false },
			})
		end,
	},

	-- Colorschemes
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
	},
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local ok, local_config = pcall(require, "config.local")
			local colorscheme = (ok and local_config.colorscheme) or "darkspectrum"
			vim.cmd("colorscheme " .. colorscheme)
		end,
	},

	-- Better notifications
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
	},
}
