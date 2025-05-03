local telescope = require("telescope")
local builtin = require("telescope.builtin")
local wk = require("which-key")

telescope.setup({
	defaults = {
		layout_config = {
			horizontal = {
				width = 0.9,
			},
		},
	},
})

wk.add({
    { "<leader>T", builtin.builtin, desc = "Telescope - find picker" },
    { "<leader> ", builtin.find_files, desc = "Find file" },
    { "<leader>f", group = "Telescope" },
    { "<leader>ff", builtin.find_files, desc = "Find file" },
    { "<leader>fg", builtin.live_grep, desc = "Live grep" },
    { "<leader>fb", builtin.buffers, desc = "Buffers" },
    { "<leader>fh", builtin.help_tags, desc = "Help tags" },
    { "<leader>ft", builtin.treesitter, desc = "Treesitter" },
    { "<leader>fr", builtin.lsp_references, desc = "References" },
    { "<leader>fc", builtin.commands, desc = "Commands" },
})

