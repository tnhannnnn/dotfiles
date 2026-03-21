return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
	end,
	dependencies = {
		"windwp/nvim-ts-autotag",
		opts = {
			opts = {
				enable_close = true, -- Auto close tags
				enable_rename = true, -- Auto rename pairs of tags
				enable_close_on_slash = true, -- Auto close on trailing </
			},
		},
	},
}
