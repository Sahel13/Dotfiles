return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  config = function()
    local ls = require("luasnip")

    ls.config.set_config({
      history = true,
      enable_autosnippets = true,
    })

    -- Make TeX snippets available in markdown
    ls.filetype_extend("markdown", { "tex" })
    ls.filetype_extend("vimwiki", { "tex" })

    vim.keymap.set({ "i", "s" }, "<tab>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<s-tab>", function()
      ls.jump(-1)
    end, { silent = true })
    vim.keymap.set("n", "<leader>es", function()
      require("luasnip.loaders").edit_snippet_files()
    end, { desc = "Edit LuaSnip Snippets" })

    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
  end,
}
