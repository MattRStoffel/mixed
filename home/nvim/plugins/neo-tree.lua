local nt = require("neo-tree.command")
local wk = require("which-key")

wk.add({
  {
    "<leader>fe",
    function()
      require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
    end,
    desc = "Explorer NeoTree",
  },
  { "<leader>e", "<leader>fe", desc = "Explorer NeoTree", remap = true },
  {
    "<leader>ge",
    function()
      require("neo-tree.command").execute({ source = "git_status", toggle = true })
    end,
    desc = "Git Explorer",
  },
  {
    "<leader>be",
    function()
      require("neo-tree.command").execute({ source = "buffers", toggle = true })
    end,
    desc = "Buffer Explorer",
  },
})
