vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		--   python = { "isort", "black" },
		--   rust = { "rustfmt", lsp_format = "fallback" },
		typescriptreact = { "prettier", stop_after_first = true },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})
