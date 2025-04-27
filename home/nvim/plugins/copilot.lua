local wk = require("which-key")

require("copilot").setup({
	panel = {
		enabled = true,
		auto_refresh = true,
		keymap = {
			jump_prev = "[[",
			jump_next = "]]",
			accept = "<CR>",
			refresh = "gr",
			open = "<M-CR>",
		},
		layout = {
			position = "bottom", -- | top | left | right
			ratio = 0.4,
		},
	},
	suggestion = {
		enabled = true,
		auto_trigger = true,
		hide_during_completion = true,
		debounce = 75,
		keymap = {
			accept = "<M-l>",
			accept_word = false,
			accept_line = false,
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
	},
	filetypes = {
		-- c = false,
	},
	copilot_node_command = "node", -- Node.js version must be > 18.x
	server_opts_overrides = {},
})
require("CopilotChat").setup({})
wk.add({
	{ "<leader>c", group = "Copilot" },
	{ "<leader>cc", "<cmd>CopilotChat<CR>", desc = "Copilot Chat" },
	{ "<leader>ce", "<cmd>CopilotChatExplain<CR>", desc = "Copilot Explain" },
	{ "<leader>cf", "<cmd>CopilotChatFix<CR>", desc = "Copilot Fix" },
})
