return {
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls", "pyright", "ruff" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("pyright", {
        settings = {
          pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              -- Ignore all files for analysis to exclusively use Ruff for linting
              ignore = { "*" },
            },
          },
        },
      })

      vim.lsp.enable({
        "lua_ls",
        "pyright",
        "ruff",
      })

      -- Keybindings
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Display hover information" })
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "[G]o to [d]efinition" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [a]ctions" })
    end,
  },
  {
    -- Support for formatters.
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>fm",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = {
          -- To fix auto-fixable lint errors.
          "ruff_fix",
          -- To run the Ruff formatter.
          "ruff_format",
          -- To organize imports.
          "ruff_organize_imports",
        },
      },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
  },
}
