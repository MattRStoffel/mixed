local lspc = require("lspconfig")

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
  on_attach = function(_, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
  end,
}

-- Setup each server with default options
for server, opts in pairs(servers) do
  lspc[server].setup(vim.tbl_deep_extend("force", default_opts, opts))
end

