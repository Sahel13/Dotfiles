return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  ft = "tex",
  keys = {
    {
      "<tab>",
      function()
        if require("luasnip").expand_or_jumpable() then
          require("luasnip").expand_or_jump()
        end
      end,
      mode = "i",
      silent = true,
    },
    {
      "<tab>",
      function()
        require("luasnip").jump(1)
      end,
      mode = "s",
      silent = true,
    },
    {
      "<s-tab>",
      function()
        require("luasnip").jump(-1)
      end,
      mode = { "i", "s" },
      silent = true,
    },
  },
  config = function()
    require("luasnip").config.set_config({
      enable_autosnippets = true,
      store_selection_keys = "<tab>",
    })
    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
  end,
}
