return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		keys = {
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find files",
			},
			{
				"<C-/>",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Search in files",
			},
		},
		dependencies = {
			-- Required
			"nvim-lua/plenary.nvim",
			-- Extensions
			{
				-- Fzf to improve sorting performance.
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			-- List selection for code actions.
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("ui-select")
		end,
	},
}
