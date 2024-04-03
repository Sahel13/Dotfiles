return {
  "lervag/vimtex",
  ft = "tex",
  init = function()
    vim.g.vimtex_quickfix_mode = 0
    vim.g.vimtex_compiler_latexmk = {
      aux_dir = "aux_dir",
      out_dir = "out_dir",
    }
    vim.g.vimtex_indent_enabled = 0
    vim.g.vimtex_subfile_start_local = 1
  end,
}
