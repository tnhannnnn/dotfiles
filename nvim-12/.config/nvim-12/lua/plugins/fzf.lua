-- vim.pack
vim.pack.add({
	{ src = "https://github.com/ibhagwan/fzf-lua" },
})
local fzf = require("fzf-lua")
fzf.setup({
	global_resume = true,
	global_resume_query = true,
	winopts = {
		height = 0.85,
		width = 0.80,
		row = 0.30,
		col = 0.50,
		border = "rounded",
		preview = {
			layout = "vertical",
			vertical = "down:60%",
			scrollbar = false,
		},
	},
	files = {
		fd_opts = table.concat({
			"--type f",
			"--hidden",
			"--follow",

			"--exclude .git",
			"--exclude node_modules",
			"--exclude .obsidian",
		}, " "),
	},
	grep = {
		rg_opts = table.concat({
			"--column",
			"--line-number",
			"--no-heading",
			"--color=always",
			"--smart-case",
			"--hidden",
			"--glob '!.git/*'",
			"--glob '!.obsidian/*'",
			"--glob '!**/.trash/**'",
			"--glob '!node_modules/*'",
			"--glob '!.obsidian/*'",
		}, " "),
	},
	lsp = {
		async_or_timeout = 3000,
		symbols = {
			symbol_icons = {
				File = "󰈙",
				Module = "󰏗",
				Class = "󰠱",
				Method = "󰆧",
				Function = "󰊕",
				Variable = "󰀫",
			},
		},
	},
	keymap = {
		builtin = {
			["<C-j>"] = "down",
			["<C-k>"] = "up",
			["<C-d>"] = "preview-page-down",
			["<C-u>"] = "preview-page-up",
		},
		fzf = {
			["alt-j"] = "down",
			["alt-k"] = "up",
		},
	},
})
-- files / buffers
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Files" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help tags" })

-- grep
vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fw", fzf.grep_cword, { desc = "Grep word" })
vim.keymap.set("v", "<leader>fw", fzf.grep_visual, { desc = "Grep selection" })

-- LSP
vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "Go to definition" })
vim.keymap.set("n", "gr", fzf.lsp_references, { desc = "References" })
vim.keymap.set("n", "gi", fzf.lsp_implementations, { desc = "Implementations" })
-- vim.keymap.set("n", "<leader>dd", function()
-- 	fzf.diagnostics_document()
-- end)
--
-- vim.keymap.set("n", "<leader>dw", function()
-- 	fzf.diagnostics_workspace()
-- end)
-- misc
vim.keymap.set("n", "<leader>:", fzf.command_history, { desc = "Command history" })
vim.keymap.set("n", "<leader>/", fzf.search_history, { desc = "Search history" })
