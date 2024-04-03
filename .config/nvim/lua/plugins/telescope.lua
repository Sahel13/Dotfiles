return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.x",
    dependencies = {
      -- Required
      "nvim-lua/plenary.nvim",
      -- Extensions
      {
        -- Fzf to improve sorting performance.
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      {
        -- List selection for code actions.
        "nvim-telescope/telescope-ui-select.nvim",
      },
    },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<C-/>", builtin.live_grep, {})
    end,
  },
}
