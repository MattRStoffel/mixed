return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "c", "rust", "go", "python", "haskell", "javascript", "typescript",
          "bash", "json", "toml", "yaml", "markdown",
        },
        auto_install = true,
        highlight    = { enable = true },
        indent       = { enable = true },
      })
    end,
  },
}
