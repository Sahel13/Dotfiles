-- General settings
vim.g.python3_host_prog = "/usr/bin/python3"
vim.o.clipboard = "unnamedplus"
vim.o.cursorline = true
vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Turn on spell check.
vim.o.spell = true
vim.o.spelllang = "en_us"

-- Scrolloff
vim.o.scrolloff = 30

-- Default tab behavior.
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.smarttab = true

-- Enable smart indenting.
vim.o.breakindent = true

-- Set highlight on search, but clear on pressing <Esc> in normal mode.
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Keymaps
vim.keymap.set({ "n" }, ";", ":")
vim.keymap.set({ "i" }, "jk", "<ESC>")

-- Set the leader key.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Easy split navigation
vim.o.splitbelow = true
vim.o.splitright = true
vim.keymap.set({ "n" }, "<C-J>", "<C-W><C-J>")
vim.keymap.set({ "n" }, "<C-K>", "<C-W><C-K>")
vim.keymap.set({ "n" }, "<C-L>", "<C-W><C-L>")
vim.keymap.set({ "n" }, "<C-H>", "<C-W><C-H>")

-- Move vertically by visual line.
vim.keymap.set({ "n" }, "j", "gj")
vim.keymap.set({ "n" }, "k", "gk")
