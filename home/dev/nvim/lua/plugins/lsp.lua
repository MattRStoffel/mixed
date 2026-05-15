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

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",        -- Lua
          "clangd",        -- C / C++
          "rust_analyzer", -- Rust
          "gopls",         -- Go
          "pyright",       -- Python
          "hls",           -- Haskell
          "ts_ls",         -- JavaScript / TypeScript
        },
        automatic_enable = true,
      })

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
