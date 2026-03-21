vim.g.have_nerd_font = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.cursorline = true
vim.o.mouse = "a"
vim.o.confirm = true
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.clipboard = "unnamedplus"
vim.opt.fillchars:append({ eob = " " })
vim.opt.shortmess:append("I")
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
	{
		"karb94/neoscroll.nvim",
		opts = {},
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	-- {
	-- 	"hrsh7th/nvim-cmp",
	-- 	event = "InsertEnter",
	-- 	dependencies = {
	-- 		-- Snippet engine (bắt buộc cho nvim-cmp)
	-- 		"L3MON4D3/LuaSnip",
	-- 		"saadparwaiz1/cmp_luasnip",
	-- 		-- Friendly snippets
	-- 		"rafamadriz/friendly-snippets",
	-- 		-- Sources
	-- 		"hrsh7th/cmp-nvim-lsp",
	-- 		"hrsh7th/cmp-buffer",
	-- 		"hrsh7th/cmp-path",
	-- 	},
	-- 	config = function()
	-- 		local cmp = require("cmp")
	-- 		local luasnip = require("luasnip")
	--
	-- 		-- Load snippets
	-- 		require("luasnip.loaders.from_vscode").lazy_load()
	--
	-- 		cmp.setup({
	-- 			snippet = {
	-- 				expand = function(args)
	-- 					luasnip.lsp_expand(args.body)
	-- 				end,
	-- 			},
	-- 			mapping = cmp.mapping.preset.insert({
	-- 				["<C-b>"] = cmp.mapping.scroll_docs(-4),
	-- 				["<C-f>"] = cmp.mapping.scroll_docs(4),
	-- 				["<C-Space>"] = cmp.mapping.complete(),
	-- 				["<C-e>"] = cmp.mapping.abort(),
	-- 				["<Tab>"] = cmp.mapping.confirm({ select = true }),
	-- 				-- Tab/Shift-Tab navigation
	-- 				["<C-n>"] = cmp.mapping(function(fallback)
	-- 					if cmp.visible() then
	-- 						cmp.select_next_item()
	-- 					elseif luasnip.expand_or_jumpable() then
	-- 						luasnip.expand_or_jump()
	-- 					else
	-- 						fallback()
	-- 					end
	-- 				end, { "i", "s" }),
	-- 				["<C-p>"] = cmp.mapping(function(fallback)
	-- 					if cmp.visible() then
	-- 						cmp.select_prev_item()
	-- 					elseif luasnip.jumpable(-1) then
	-- 						luasnip.jump(-1)
	-- 					else
	-- 						fallback()
	-- 					end
	-- 				end, { "i", "s" }),
	-- 			}),
	-- 			sources = cmp.config.sources({
	-- 				-- obsidian.nvim sẽ tự động thêm sources của nó vào đây
	-- 				{ name = "nvim_lsp" },
	-- 				{ name = "luasnip" },
	-- 				{ name = "path" },
	-- 			}, {
	-- 				{ name = "buffer" },
	-- 			}),
	-- 			formatting = {
	-- 				fields = { "abbr", "kind", "menu" },
	-- 				format = function(entry, item)
	-- 					local menu_icon = {
	-- 						nvim_lsp = "[LSP]",
	-- 						luasnip = "[Snip]",
	-- 						buffer = "[Buf]",
	-- 						path = "[Path]",
	-- 						-- Obsidian sources sẽ tự thêm icon
	-- 					}
	-- 					item.menu = menu_icon[entry.source.name] or string.format("[%s]", entry.source.name)
	-- 					return item
	-- 				end,
	-- 			},
	-- 			window = {
	-- 				completion = cmp.config.window.bordered(),
	-- 				documentation = cmp.config.window.bordered(),
	-- 			},
	-- 		})
	-- 	end,
	-- },
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
			-- vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
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
			{ "<leader>ff", "<cmd>Obsidian quick_switch<CR>" },
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
vim.keymap.set("i", "<C-b>", function()
	return "****<Left><Left>"
end, { expr = true, noremap = true })

-- Insert ** and move cursor to the middle
vim.keymap.set("i", "<C-u>", function()
	return "**<Left>"
end, { expr = true, noremap = true })
