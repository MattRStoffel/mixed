return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts         = {},
    keys = {
      { "<Leader><Leader>", function() require("telescope.builtin").find_files() end, desc = "Telescope: find files" },
      { "<Leader>/",        function() require("telescope.builtin").live_grep()  end, desc = "Telescope: live grep"  },
      { "<Leader>b",        function() require("telescope.builtin").buffers()    end, desc = "Telescope: buffers"    },
    },
  },
}
