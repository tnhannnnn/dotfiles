return {
	"nvim-mini/mini.nvim",
	version = "*",
	config = function()
		require("mini.statusline").setup()
		require("mini.icons").setup()
	end,
}
