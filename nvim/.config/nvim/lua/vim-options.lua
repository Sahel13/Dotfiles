-- Set the leader key.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- Run Lua code
vim.keymap.set("n", "<space><space>x", "<Cmd>source %<CR>")
vim.keymap.set("n", "<space>x", "<Cmd>.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)

-- General settings
vim.g.python3_host_prog = "/usr/bin/python3"
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
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.expandtab = true

-- Set highlight on search.
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear highlights." })

-- Easy split navigation
vim.o.splitbelow = true
vim.o.splitright = true
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Terminal emulator
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>", { desc = "Escape insert mode in terminal" })
vim.keymap.set("n", "<Space>st", function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 8)
end, { desc = "Small terminal" })

-- Diagnostics for lsp.
vim.opt.winborder = "rounded"

-- Markdown conceal settings
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = ""
    end,
})

-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
vim.o.confirm = true

-- Quickfix list.
vim.keymap.set("n", "<leader>q", ":copen<CR>", { noremap = true, desc = "Open the quickfix list" })
vim.keymap.set("n", "<leader>Q", ":cclose<CR>", { noremap = true, desc = "Close the quickfix list" })
