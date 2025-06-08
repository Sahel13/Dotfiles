-- Set the leader key.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General settings
vim.g.python3_host_prog = "/usr/bin/python3"
vim.o.clipboard = "unnamedplus"
vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.termguicolors = true
vim.o.scrolloff = 30
vim.o.breakindent = true
vim.o.textwidth = 100

-- Turn on spell check.
vim.o.spell = true
vim.o.spelllang = "en_us"
vim.keymap.set({ "i" }, "<C-l>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { desc = "Fix the most recent spelling mistake." })

-- Default tab behavior.
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.smarttab = true

-- Set highlight on search, but clear on pressing <Esc> in normal mode.
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Easy split navigation
vim.o.splitbelow = true
vim.o.splitright = true
vim.keymap.set({ "n" }, "<C-J>", "<C-W><C-J>")
vim.keymap.set({ "n" }, "<C-K>", "<C-W><C-K>")
vim.keymap.set({ "n" }, "<C-L>", "<C-W><C-L>")
vim.keymap.set({ "n" }, "<C-H>", "<C-W><C-H>")
