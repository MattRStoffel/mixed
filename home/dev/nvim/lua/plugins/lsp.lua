return {
  { "williamboman/mason.nvim", opts = {} },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",   -- registers default server configs into vim.lsp.config
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Global defaults applied to every server.
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local map  = vim.keymap.set
          local opts = { buffer = event.buf }
          map("n", "gd",         vim.lsp.buf.definition,  opts)
          map("n", "K",          vim.lsp.buf.hover,       opts)
          map("n", "gr",         vim.lsp.buf.references,  opts)
          map("n", "<leader>rn", vim.lsp.buf.rename,      opts)
          map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",        -- Lua
          "clangd",        -- C / C++
          "rust_analyzer", -- Rust
          "gopls",         -- Go
          "pyright",       -- Python
          "ts_ls",         -- JavaScript / TypeScript
        },
        automatic_enable = true,
      })

      -- hls: provided externally, not via mason.
      vim.lsp.enable("hls")

      -- sourcekit ships with Xcode (xcrun) so mason can't install it.
      vim.lsp.config("sourcekit", {
        cmd          = { "xcrun", "sourcekit-lsp" },
        filetypes    = { "swift", "objective-c", "objective-cpp" },
        root_markers = { "Package.swift", "*.xcodeproj", ".git" },
      })
      vim.lsp.enable("sourcekit")
    end,
  },
}
