local harpoon_configs = {
  keys = {
    -- Harpoon marked files 1 through 4
    {"<leader>p1",
      function()
        require("harpoon.ui").nav_file(1)
      end, desc ="Harpoon buffer 1"
    },

    {"<leader>p2",
      function()
        require("harpoon.ui").nav_file(2)
      end, desc ="Harpoon buffer 2"
    },

    {"<leader>p3",
      function()
        require("harpoon.ui").nav_file(3)
      end, desc ="Harpoon buffer 3"
    },

    {"<leader>p4",
      function()
        require("harpoon.ui").nav_file(4)
      end, desc ="Harpoon buffer 4"
    },

    -- Harpoon next and previous.
    {"<leader>pn",
      function()
        require("harpoon.ui").nav_next()
      end, desc ="Harpoon next buffer"
    },

    {"<leader>pp",
      function()
        require("harpoon.ui").nav_prev()
      end, desc ="Harpoon prev buffer"
    },

    -- Harpoon user interface.
    {"<leader>pl",
      function()
        local harpoon = require("harpoon.ui")
        harpoon.toggle_quick_menu()
      end, desc ="Harpoon Toggle Menu"
    },

    {"<leader>pa",
      function()
        require("harpoon.mark").add_file()
      end, desc ="Harpoon Tadd file"
    },
  },

  opts = {
    settings = {
      enter_on_sendcmd = false,
      excluded_filetypes = { "harpoon", "alpha", "dashboard", "gitcommit" },
      mark_branch = false,
      save_on_change = true,
      save_on_toggle = false,
      sync_on_ui_close = false,
      tmux_autoclose_windows = false,
    },
  },
}

return harpoon_configs
