return {
  "vimwiki/vimwiki",
  keys = "<leader>ww",
  init = function()
    vim.g.vimwiki_list = {
      {
        path = "~/Documents/zettelkasten",
        syntax = "markdown",
        ext = ".md",
      },
    }
    vim.g.vimwiki_global_ext = 0
    vim.g.vimwiki_markdown_link_ext = 1
  end,
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "vimwiki",
      callback = function()
        -- Disable <Tab> in insert mode - this is used by LuaSnip.
        vim.keymap.del("i", "<Tab>", { buffer = true })
      end,
    })
  end,
}
