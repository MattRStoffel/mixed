local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")

map("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left window"  })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper window" })

map("n", "<M-,>", "<C-w>5<")
map("n", "<M-.>", "<C-w>5>")
map("n", "<M-t>", "<C-w>5+")
map("n", "<M-s>", "<C-w>5-")

-- python3 ships with macOS; `python` does not.
vim.api.nvim_create_user_command("FormatJson", ":%!python3 -m json.tool", {})
map("n", "<Leader>j", ":FormatJson<CR>", { desc = "Format buffer as JSON" })

-- Telescope (wrapped in functions so lazy can defer loading until first use)
map("n", "<Leader><Leader>", function() require("telescope.builtin").find_files() end, { desc = "Telescope: find files" })
map("n", "<Leader>/",        function() require("telescope.builtin").live_grep()  end, { desc = "Telescope: live grep"  })
map("n", "<Leader>b",        function() require("telescope.builtin").buffers()    end, { desc = "Telescope: buffers"    })

-- LSP (buffer-local, set whenever a server attaches)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf }
    map("n", "gd",          vim.lsp.buf.definition,  opts)
    map("n", "K",           vim.lsp.buf.hover,       opts)
    map("n", "gr",          vim.lsp.buf.references,  opts)
    map("n", "<leader>rn",  vim.lsp.buf.rename,      opts)
    map("n", "<leader>ca",  vim.lsp.buf.code_action, opts)
  end,
})
