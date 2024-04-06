return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "lua_ls", "pylsp" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- Lua language server setup.
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				settings = {
					Lua = { diagnostics = { globals = { "vim" } } },
				},
			})

			-- Python language server setup.
			lspconfig.pylsp.setup({
				settings = {
					pylsp = {
						plugins = { pycodestyle = { ignore = { "E501", "E203" } } },
					},
				},
			})

			-- Keybindings
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Display hover information" })
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "[G]o to [d]efinition" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [a]ctions" })
		end,
	},
	{
		-- Support for formatters.
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>fm",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
			},
			format_on_save = { timeout_ms = 500, lsp_fallback = true },
		},
	},
}
