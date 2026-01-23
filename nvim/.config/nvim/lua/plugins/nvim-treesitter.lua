return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "haskell", "python", "julia" },
            sync_install = false,
            auto_install = false,
            highlight = {
                enable = true,
                disable = { "latex", "markdown" },
            },
            indent = { enable = true },
        })
    end,
}
