require("vim._core.ui2").enable({})
require("options")
--plugin
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
	{ src = "https://github.com/brenoprata10/nvim-highlight-colors" },
	{ src = "https://github.com/gbprod/nord.nvim" },
})
vim.api.nvim_create_user_command("PackUpdate", function()
	vim.pack.update()
end, {})
vim.cmd.colorscheme("nord")
require("nvim-highlight-colors").setup({
	enable_tailwind = true,
})
require("mason").setup({})
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.fn.stdpath("config") == vim.loop.cwd() and { vim.env.VIMRUNTIME } or {},
			},
		},
	},
})
vim.lsp.enable({ "lua_ls", "clangd", "ts_ls", "tailwindcss" })
-- require("nvim-treesitter")
-- 	.install({
-- 		"lua",
-- 		"vim",
-- 		"vimdoc",
-- 		"c",
-- 		"cpp",
-- 		"html",
-- 		"typescript",
-- 		"tsx",
-- 		"jsx",
-- 		"javascript",
-- 		"python",
-- 		"markdown",
-- 	})
vim.api.nvim_create_autocmd({ "FileType" }, {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

local severity = vim.diagnostic.severity
vim.diagnostic.config({
	signs = {
		text = {
			[severity.ERROR] = " ",
			[severity.WARN] = " ",
			[severity.HINT] = "󰠠 ",
			[severity.INFO] = " ",
		},
	},
})
vim.keymap.set("n", "<leader>ca", function()
	vim.lsp.buf.code_action({
		filter = function(action)
			return not action.disabled
		end,
	})
end)
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {})
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>lo", "<cmd>lopen<CR>", { silent = true })
vim.keymap.set("n", "<leader>lx", "<cmd>lclose<CR>", { silent = true })
vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.diagnostic.setloclist({ open = false })
	end,
})
-- vim.o.statusline = table.concat({
-- 	" %{v:lua.require'statusline'.mode()} ",
-- 	"| %f%m",
-- 	"| %{v:lua.require'statusline'.git_branch()} ",
-- 	"%=",
-- 	"%{v:lua.require'statusline'.diagnostics()} ",
-- 	"%l:%c ",
-- 	"%p%% ",
-- })
require("plugins.format")
require("plugins.fzf")
require("plugins.completion")
require("plugins.mini")
require("plugins.neotree")
