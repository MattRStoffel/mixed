return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- Use the new module name here
    require('nvim-treesitter').setup({ 
      ensure_installed = {
        "lua", "c", "rust", "go", "python", "haskell", "javascript", "typescript",
        "bash", "json", "toml", "yaml", "markdown",
      },
      auto_install = true,
      highlight    = { enable = true },
      indent       = { enable = true },
    })
  end
}
