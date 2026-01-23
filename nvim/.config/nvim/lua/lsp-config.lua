-- Keymaps
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Display hover information" })
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "[G]o to [d]efinition" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [a]ctions" })
vim.keymap.set("n", "<leader>cd", function()
    vim.diagnostic.open_float()
end, { desc = "[C]ode [d]iagnostics" })

-- Enable LSPs
vim.lsp.enable({ "lua_ls", "stylua", "ty", "ruff", "ts_ls", "clangd", "prettier" })

-- Stop lua_ls complaining "Undefined global `vim`".
vim.lsp.config("lua_ls", {
    settings = {
        Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true) } },
    },
})

vim.lsp.config("prettier", {})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("my.lsp", { clear = true }),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        -- Disable hover from Ruff (let Pyright handle it)
        if client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
        end

        -- Auto-format on save
        if
            not client:supports_method("textDocument/willSaveWaitUntil")
            and client:supports_method("textDocument/formatting")
        then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end
    end,
})
