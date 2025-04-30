local lspc = require("lspconfig")

local clangd_opts = {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=never",
		"--compile-commands-dir=.", -- Ensure it's set correctly
		"--query-driver=/usr/bin/gcc,/usr/bin/clang", -- Adjust if needed
	},
}

-- List of language servers to configure
local servers = {
	pyright = {}, -- Python
	lua_ls = {}, -- Lua
	nil_ls = {}, -- Nix
	-- clangd = clangd_opts, -- C, C++
	ccls = {},
	bashls = {}, -- Shell scripting
	gopls = {}, -- Go
	texlab = {}, -- LaTeX
	ts_ls = {},
	astro = {}, -- astro
	glsl_analyzer = {}, -- glsl
}

-- Default options for all servers
local default_opts = {
	capabilities = require("cmp_nvim_lsp").default_capabilities(), -- Need nvim-cmp installed for this
	on_attach = function(_, bufnum)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnum })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnum })
		vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnum })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnum })
		vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { buffer = bufnum })
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnum })
	end,
}

-- Setup each server with default options
for server, opts in pairs(servers) do
	lspc[server].setup(vim.tbl_deep_extend("force", default_opts, opts))
end
