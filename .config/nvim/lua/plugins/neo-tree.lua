return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.keymap.set("n", "<leader>ft", ":Neotree reveal<CR>", {})
		vim.keymap.set("n", "<leader>ob", ":Neotree toggle show buffers left<CR>", {})
	end,
}
