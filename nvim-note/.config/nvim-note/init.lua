vim.g.have_nerd_font = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smartindent = false
vim.o.autoindent = false
vim.o.cursorline = true
vim.o.mouse = "a"
vim.o.confirm = true
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.clipboard = "unnamedplus"
vim.opt.fillchars:append({ eob = " " })
vim.g.mapleader = " "
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.o.cmdheight = 0
vim.o.showcmd = true
vim.opt.laststatus = 0
vim.opt.scrolloff = 10
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "md" },
	callback = function()
		vim.opt_local.wrap = false
	end,
})
-- keymap
local map = vim.keymap.set
map("n", "<leader>bn", "<cmd>bnext<CR>", { silent = true })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { silent = true })
map("n", "<leader>bx", "<cmd>bdelete<CR>", { silent = true })
map("n", "<Esc>", "<cmd>noh<CR><Esc>", { silent = true })
map("n", "<C-h>", "<C-w>h", {})
map("n", "<C-j>", "<C-w>j", {})
map("n", "<C-k>", "<C-w>k", {})
map("n", "<C-l>", "<C-w>l", {})
map("i", "<A-h>", "<Left>", {})
map("i", "<A-j>", "<Down>", {})
map("i", "<A-k>", "<Up>", {})
map("i", "<A-l>", "<Right>", {})
map("n", "<leader>t", ":colorscheme ")
map("n", "j", "gj", {})
map("n", "k", "gk", {})
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			color_overrides = {
				all = {
					blue = "#b4befe",
				},
			},
		},
	},
	{ "rose-pine/neovim", name = "rose-pine" },
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install({ "markdown" })
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				char = "│",
			},
			scope = {
				enabled = false,
			},
			whitespace = {
				remove_blankline_trail = true,
			},
		},
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		requires = "nvim-tree/nvim-web-devicons",
		opts = {},
	},
	{ enabled = true, "karb94/neoscroll.nvim", opts = {} },

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		opts = {
			keymap = { preset = "super-tab" },

			appearance = {
				nerd_font_variant = "mono",
			},
			completion = { documentation = { auto_show = false } },
			sources = {
				default = { "obsidian", "obsidian_tags", "obsidian_new", "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- optional but recommended
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							preview_width = 0.5, -- rất quan trọng
							results_width = 0.5,
						},
						width = 0.95,
						height = 0.9,
						prompt_position = "top",
					},
					sorting_strategy = "ascending",
					preview = {
						treesitter = true,
					},
				},
			})
			require("telescope").load_extension("ui-select")
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		lazy = false,
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			heading = {
				enabled = true,
				icons = { "", "", "", "", "", "" }, -- không số, không icon
				position = "inline",
			},
		},
	},
	{
		"obsidian-nvim/obsidian.nvim",
		version = "3.15.10",
		lazy = false,
		keys = {
			{ "<leader>gf", "<cmd>Obsidian follow_link<CR>" },
			{ "<leader>ch", "<cmd>Obsidian toggle_checkbox<CR>" },
			{ "<leader>ot", "<cmd>Obsidian today<CR>" },
			{ "<leader>od", "<cmd>Obsidian dailies<CR>" },
			{ "<leader>on", "<cmd>Obsidian new_from_template<CR>" },
			{ "<leader>ob", "<cmd>Obsidian backlinks<CR>" },
			{ "<leader>or", "<cmd>Obsidian rename<CR>" },
			-- { "<leader>ff", "<cmd>Obsidian quick_switch<CR>" },
			{ "<leader>os", "<cmd>Obsidian tags<CR>" },
		},
		opts = {
			legacy_commands = false,
			workspaces = {
				{
					name = "personal",
					path = "/Users/tnhannn/Library/Mobile Documents/iCloud~md~obsidian/Documents/Note/",
				},
			},
			ui = {
				enable = false,
				ignore_conceal_warn = true,
			},
			templates = {
				folder = "templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
			},
			note_id_func = function(title)
				if title ~= nil and title ~= "" then
					return title
				end
				return os.time()
			end,
			notes_subdir = ".",
			new_notes_location = ".",
			frontmatter = {
				enabled = false,
			},
			daily_notes = {
				folder = "daily",
				date_format = "%Y-%m-%d",
				template = "daily.md",
				workdays_only = false,
			},
			checkbox = {
				enabled = true,
				create_new = false,
				order = { " ", "-", "x" },
			},
			completion = {
				nvim_cmp = false,
				blink = true,
			},
		},
	},
	{
		-- "tnhannnnn/logseq-mode.nvim",
		dir = "~/test/logseq-mode.nvim/",
		main = "logseq_mode",
		keys = {
			{ "<leader>dl", "<cmd>LogseqDaily<CR>", { desc = "Open logseq daily page" } },
		},
		dependencies = {
			{
				"stevearc/conform.nvim",
				opts = function(_, opts)
					opts.formatters_by_ft = opts.formatters_by_ft or {}

					-- Add logseq_fixer to markdown
					-- It only runs if the file is inside the configured logseq_dir
					if not opts.formatters_by_ft.markdown then
						opts.formatters_by_ft.markdown = { "logseq_fixer" }
					else
						table.insert(opts.formatters_by_ft.markdown, "logseq_fixer")
					end
				end,
			}, -- Optional, for formatting
			"folke/snacks.nvim", -- Optional, for grep picker
		},
		opts = {
			logseq_dir = "~/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents/Note/", -- Path to your graph
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false, -- neo-tree will lazily load itself
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle right<CR>" },
		},
		opts = {
			window = { width = 30, position = "right", statusline = false, winbar = false },
			filesystem = {
				filtered_items = {
					hide_by_name = {
						".DS_Store",
						"thumbs.db",
						--"node_modules",
					},
				},
			},
		},
	},
	-- {
	-- 	"3rd/image.nvim",
	-- 	build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
	-- 	opts = {
	-- 		processor = "magick_cli",
	-- 		integrations = {
	-- 			markdown = {
	-- 				enabled = true,
	-- 				clear_in_insert_mode = false,
	-- 				download_remote_images = true,
	-- 				only_render_image_at_cursor = true,
	-- 				only_render_image_at_cursor_mode = "popup",
	-- 				floating_windows = false,
	-- 				filetypes = { "markdown" },
	-- 			},
	-- 		},
	-- 	},
	-- },
}, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
vim.cmd("colorscheme catppuccin")
require("task_organizer")
require("autowrite")
vim.keymap.set("n", "<leader>w", function()
	local wrap = vim.opt.wrap:get()
	vim.opt.wrap = not wrap
	vim.opt.linebreak = not wrap
	vim.opt.breakindent = not wrap
end, {
	desc = "Toggle wrap + linebreak + breakindent",
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function(args)
		vim.treesitter.start(args.buf, "markdown")
	end,
})
-- Insert **** and move cursor to the middle
-- vim.keymap.set("i", "<C-b>", function()
-- 	return "****<Left><Left>"
-- end, { expr = true, noremap = true })
--
-- -- Insert ** and move cursor to the middle
-- vim.keymap.set("i", "<C-u>", function()
-- 	return "**<Left>"
-- end, { expr = true, noremap = true })
