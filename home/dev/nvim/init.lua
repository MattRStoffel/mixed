local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("config.options")
require("config.keymaps")

require("lazy").setup({
  { import = "plugins" },
}, {
  rocks       = { enabled = false },
  performance = {
    reset_packpath = false,
    rtp            = { reset = false },
  },
})

vim.cmd.colorscheme("nix-theme")
