vim.pack.add({
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = vim.version.range("3") },
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})
require("neo-tree").setup({
	window = { width = 30, position = "right", statusline = false },
	filesystem = {
		filtered_items = {
			visible = false,
			hide_dotfiles = false,
			hide_gitignored = false,
		},
	},
})
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle right<CR>", { silent = true })
vim.keymap.set("n", "<leader>E", "<cmd>Neotree toggle current<CR>", { silent = true })
