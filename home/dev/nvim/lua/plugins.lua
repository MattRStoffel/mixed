-- If lazy was already added to the rtp before this file runs (e.g. by a
-- package manager), preserve the existing rtp/packpath rather than resetting.
local lazy_managed = vim.fn.isdirectory(vim.fn.stdpath("data") .. "/lazy/lazy.nvim") == 0

require("lazy").setup({

  -- ── Telescope ────────────────────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    tag          = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts         = {},
  },

  -- ── Mason ─────────────────────────────────────────────────────────────────
  { "williamboman/mason.nvim", opts = {} },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",   -- registers default server configs into vim.lsp.config
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Global defaults applied to every server — no per-server setup() calls needed.
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        on_attach    = function(_, bufnr)
          local map  = vim.keymap.set
          local opts = { buffer = bufnr }
          map("n", "gd",          vim.lsp.buf.definition,  opts)
          map("n", "K",           vim.lsp.buf.hover,       opts)
          map("n", "gr",          vim.lsp.buf.references,  opts)
          map("n", "<leader>rn",  vim.lsp.buf.rename,      opts)
          map("n", "<leader>ca",  vim.lsp.buf.code_action, opts)
        end,
      })

      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "hls" },
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

  -- ── nvim-cmp ─────────────────────────────────────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"]     = cmp.mapping.select_next_item(),
          ["<C-p>"]     = cmp.mapping.select_prev_item(),
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources(
          { { name = "nvim_lsp" }, { name = "luasnip" } },
          { { name = "buffer"   }, { name = "path"    } }
        ),
      })
    end,
  },

}, {
  performance = {
    reset_packpath = not lazy_managed,
    rtp            = { reset = not lazy_managed },
  },
})
