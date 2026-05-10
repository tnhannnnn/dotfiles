-- CoreUI2
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		targets = "msg",
		cmd = {
			height = 0.5,
		},
		dialog = {
			height = 0.5,
		},
		msg = {
			height = 0.5,
			timeout = 4000,
		},
		pager = {
			height = 1,
		},
	},
})
-- Basic option
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.number = true
vim.o.relativenumber = true
vim.opt.confirm = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.o.cursorline = true
vim.o.termguicolors = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.cmdheight = 0
vim.cmd[[colorscheme habamax]]
-- Basic keymaps
local map = vim.keymap.set
map({ "n", "t" }, "<C-h>", [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
map({ "n", "t" }, "<C-j>", [[<C-\><C-n><C-w>j]], { noremap = true, silent = true })
map({ "n", "t" }, "<C-k>", [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })
map({ "n", "t" }, "<C-l>", [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })
map("n", "<Esc>", "<cmd>noh<CR><Esc>", { silent = true })
map("n", "<leader>tn", "<cmd>tabnew<CR>", { silent = true })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { silent = true })
-- Compile & run C++ file
vim.keymap.set("n", "<leader>bc", function()
	local file = vim.fn.expand("%:p")
	local output = vim.fn.expand("%:r")
	vim.cmd('botright 15split | terminal g++ "' .. file .. '" -o "' .. output .. '" && "' .. output .. '"')
end, { desc = "Build & run C++ file" })
-- Run python file
vim.keymap.set("n", "<leader>bp", function()
	local file = vim.fn.expand("%:p")
	vim.cmd('botright 15split | terminal python3 "' .. file .. '"')
end, { desc = "Run Python file" })

-- LSP
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
})
require("mason").setup({})
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
vim.lsp.enable({ "clangd", "pyright", "ruff" })
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
-- Autocomplete
vim.o.autocomplete = true
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		if client:supports_method("textDocument/implementation") then
			-- Create a keymap for vim.lsp.buf.implementation ...
		end

		-- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
		if client:supports_method("textDocument/completion") then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			-- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			-- client.server_capabilities.completionProvider.triggerCharacters = chars

			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end

		-- Auto-format ("lint") on save.
		-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
		if
			not client:supports_method("textDocument/willSaveWaitUntil")
			and client:supports_method("textDocument/formatting")
		then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
				buffer = ev.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})
vim.opt.complete:append("o")
vim.opt.completeopt = { "menuone", "noselect" }
vim.o.pumheight = 10
vim.keymap.set("i", "<Tab>", function()
	return vim.fn.pumvisible() == 1 and "<C-y>" or "<Tab>"
end, { expr = true })
-- Scripts
-- # Autopairs

local M = {}

-- Danh sách các cặp ký tự
local pairs_map = {
	["("] = ")",
	["["] = "]",
	["{"] = "}",
	['"'] = '"',
	["'"] = "'",
	["`"] = "`",
}

-- Danh sách ký tự đóng (để xử lý skip khi đã có sẵn)
local close_chars = { ")", "]", "}", '"', "'", "`" }

-- Hàm kiểm tra ký tự bên phải con trỏ
local function char_at_cursor()
	local col = vim.fn.col(".") -- vị trí cột hiện tại
	local line = vim.fn.getline(".") -- nội dung dòng hiện tại
	return line:sub(col, col) -- lấy 1 ký tự tại vị trí con trỏ
end

-- Hàm kiểm tra ký tự bên trái con trỏ
local function char_before_cursor()
	local col = vim.fn.col(".")
	local line = vim.fn.getline(".")
	return line:sub(col - 1, col - 1)
end

-- Xử lý khi gõ ký tự MỞ: (, [, {, ", ', `
local function handle_open(open, close)
	return function()
		-- Chèn cặp ký tự rồi di chuyển con trỏ vào giữa
		return open .. close .. "<Left>"
	end
end

-- Xử lý khi gõ ký tự ĐÓNG: ), ], }
-- Nếu ký tự bên phải đã là ký tự đóng → chỉ di chuyển qua, không chèn thêm
local function handle_close(close)
	return function()
		if char_at_cursor() == close then
			return "<Right>" -- nhảy qua ký tự đóng đã có sẵn
		else
			return close -- gõ bình thường
		end
	end
end

-- Xử lý riêng cho quote: ", ', `
-- Vì chúng vừa là ký tự mở vừa là ký tự đóng
local function handle_quote(char)
	return function()
		local next_char = char_at_cursor()
		local prev_char = char_before_cursor()

		-- Nếu bên phải đã có ký tự quote giống → nhảy qua
		if next_char == char then
			return "<Right>"
		end

		-- Nếu bên trái là chữ cái hoặc số → gõ bình thường (không wrap)
		if prev_char:match("[%w_]") then
			return char
		end

		-- Còn lại → chèn cặp
		return char .. char .. "<Left>"
	end
end

-- Xử lý phím Backspace
-- Nếu con trỏ đang ở giữa cặp rỗng () [] {} "" '' `` → xóa cả 2
local function handle_backspace()
	local next_char = char_at_cursor()
	local prev_char = char_before_cursor()

	for open, close in pairs(pairs_map) do
		if prev_char == open and next_char == close then
			return "<BS><Del>" -- xóa ký tự trái và phải
		end
	end

	return "<BS>" -- xóa bình thường
end

-- Xử lý phím Enter
-- Nếu con trỏ ở giữa {} → tự động xuống dòng và indent đẹp
local function handle_enter()
	local next_char = char_at_cursor()
	local prev_char = char_before_cursor()

	if prev_char == "{" and next_char == "}" then
		return "<CR><CR><Up><End>" -- tạo dòng trống ở giữa, đặt con trỏ vào đó
	end

	return "<CR>"
end

-- Hàm setup chính: đăng ký tất cả keymaps
function M.setup()
	local opts = {
		expr = true, -- keymap trả về biểu thức (chuỗi ký tự để chèn)
		noremap = true,
		silent = true,
	}

	-- Map ký tự mở
	for open, close in pairs(pairs_map) do
		-- Bỏ qua quote ở đây, xử lý riêng bên dưới
		if open ~= close then
			vim.keymap.set("i", open, handle_open(open, close), opts)
		end
	end

	-- Map ký tự đóng (chỉ ), ], })
	vim.keymap.set("i", ")", handle_close(")"), opts)
	vim.keymap.set("i", "]", handle_close("]"), opts)
	vim.keymap.set("i", "}", handle_close("}"), opts)

	-- Map quote
	vim.keymap.set("i", '"', handle_quote('"'), opts)
	vim.keymap.set("i", "'", handle_quote("'"), opts)
	vim.keymap.set("i", "`", handle_quote("`"), opts)

	-- Map Backspace
	vim.keymap.set("i", "<BS>", handle_backspace, opts)

	-- Map Enter
	vim.keymap.set("i", "<CR>", handle_enter, opts)
end
M.setup()
-- terminal
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		local opts = { noremap = true, silent = true, buffer = true }
		vim.keymap.set("n", "q", function()
			vim.cmd("bd!")
		end, opts)
	end,
})
--  File explorer and Finder
vim.pack.add({
	{
		src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
		version = vim.version.range("3"),
	},
	-- dependencies
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	-- optional, but recommended
	"https://github.com/nvim-tree/nvim-web-devicons",
	{ src = "https://github.com/ibhagwan/fzf-lua" },
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
vim.keymap.set("n", "<leader>:", fzf.command_history, { desc = "Command history" })
vim.keymap.set("n", "<leader>/", fzf.search_history, { desc = "Search history" })
