vim.g.mapleader      = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

local o = vim.opt
o.expandtab      = true
o.tabstop        = 2
o.shiftwidth     = 2
o.softtabstop    = 2
o.number         = true
o.relativenumber = true
o.mouse          = "a"
o.breakindent    = true
o.undofile       = true
o.ignorecase     = true
o.smartcase      = true
o.signcolumn     = "yes"
o.updatetime     = 250
o.timeoutlen     = 300
o.splitright     = true
o.splitbelow     = true
o.inccommand     = "split"
o.cursorline     = true
o.scrolloff      = 6
o.completeopt    = { "menu", "menuone", "noselect" }
o.pumheight      = 5
o.termguicolors  = true
o.shortmess:append("c")

vim.schedule(function() o.clipboard = "unnamedplus" end)
