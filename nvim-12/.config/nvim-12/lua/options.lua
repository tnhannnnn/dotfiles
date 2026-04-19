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
--keymaps
local map = vim.keymap.set
map({ "n", "t" }, "<C-h>", [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
map({ "n", "t" }, "<C-j>", [[<C-\><C-n><C-w>j]], { noremap = true, silent = true })
map({ "n", "t" }, "<C-k>", [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })
map({ "n", "t" }, "<C-l>", [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })
map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
map("n", "<Esc>", "<cmd>noh<CR><Esc>", { silent = true })
map("n", "<leader>tn", "<cmd>tabnew<CR>", { silent = true })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { silent = true })
