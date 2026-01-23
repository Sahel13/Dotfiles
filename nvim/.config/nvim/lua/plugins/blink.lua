return {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
        keymap = {
            preset = "default",
            ["<C-e>"] = false,
            ["<Enter>"] = { "select_and_accept", "fallback" },
        },
        appearance = {
            nerd_font_variant = "mono",
        },
        -- (Default) Only show the documentation popup when manually triggered
        completion = { documentation = { auto_show = false } },
        sources = {
            default = { "lsp", "path", "snippets", "omni", "notes" },
            providers = {
                notes = {
                    name = "Notes",
                    module = "notes",
                },
            },
        },
    },
    opts_extend = { "sources.default" },
}
