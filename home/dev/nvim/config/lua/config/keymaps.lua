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
