local lspc = require("lspconfig")
local capabilities = 

-- List of language servers to configure
local servers = {
  pyright = {},           -- Python
  lua_ls = {},            -- Lua
  nil_ls = {},            -- Nix
  clangd = {},            -- C, C++
  bashls = {},            -- Shell scripting
  gopls = {},             -- Go
  texlab = {},            -- LaTeX
}

-- Default options for all servers
local default_opts = {
  capabilities = require('cmp_nvim_lsp').default_capabilities(), -- Need nvim-cmp installed for this
  on_attach = function()
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer=0})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer=0})
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_defenition, {buffer=0})
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer=0})
    vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', {buffer=0})
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, {buffer=0})
  end,
}

-- Setup each server with default options
for server, opts in pairs(servers) do
  lspc[server].setup(vim.tbl_deep_extend("force", default_opts, opts))
end

