local lazy_managed = vim.fn.isdirectory(vim.fn.stdpath("data") .. "/lazy/lazy.nvim") == 0

require("lazy").setup("plugins", {
  performance = {
    reset_packpath = not lazy_managed,
    rtp            = { reset = not lazy_managed },
  },
})
