return {
  "sainnhe/gruvbox-material",
  lazy = false,
  priority = 1000,
  init = function()
    vim.o.background = "dark"
    vim.g.gruvbox_material_background = "medium"
    vim.g.gruvbox_material_better_performance = 1
  end,
  config = function()
    vim.cmd.colorscheme("gruvbox-material")
  end,
}
