return {
  {
    'saghen/blink.cmp',
    version = '1.*',
    opts = {
      keymap = { preset = 'default' },
      appearance = {
        nerd_font_variant = 'mono'
      },
      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = false } },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'omni', },
      },
    },
    opts_extend = { "sources.default" }
  }
}
