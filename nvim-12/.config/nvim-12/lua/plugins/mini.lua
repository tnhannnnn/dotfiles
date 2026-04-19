vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.nvim" },
})
require("mini.ai").setup()
require("mini.surround").setup()
require("mini.pick").setup()
require("mini.statusline").setup()
require("mini.indentscope").setup()
-- require("mini.notify").setup()
require("mini.pairs").setup()
vim.ui.pick = require("mini.pick").pick
