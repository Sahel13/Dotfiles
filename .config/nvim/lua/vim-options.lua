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

-- Turn on spell check.
vim.o.spell = true
vim.o.spelllang = "en_us"
vim.keymap.set("i", "<C-l>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { desc = "Fix the most recent spelling mistake." })

-- Default tab behavior.
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.smarttab = true

-- Set highlight on search.
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear highlights." })

-- Easy split navigation
vim.o.splitbelow = true
vim.o.splitright = true
vim.keymap.set({ "n" }, "<C-J>", "<C-W><C-J>")
vim.keymap.set({ "n" }, "<C-K>", "<C-W><C-K>")
vim.keymap.set({ "n" }, "<C-L>", "<C-W><C-L>")
vim.keymap.set({ "n" }, "<C-H>", "<C-W><C-H>")

-- Terminal emulator
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>", { desc = "Escape insert mode in terminal" })
vim.keymap.set("n", "<Space>st", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)
end, { desc = "Small terminal" })

-- Diagnostics for lsp.
vim.diagnostic.config({ virtual_lines = true })
vim.opt.winborder = "rounded"
