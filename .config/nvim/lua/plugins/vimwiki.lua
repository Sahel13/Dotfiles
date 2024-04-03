return {
  "vimwiki/vimwiki",
  keys = "<leader>ww",
  init = function()
    vim.g.vimwiki_list = {
      {
        path = "~/Documents/vimwiki",
        syntax = "markdown",
        ext = ".md",
      },
    }
    vim.g.vimwiki_global_ext = 0
    vim.g.vimwiki_markdown_link_ext = 1
  end,
}
