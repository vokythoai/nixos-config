return {
  -- Disable Mason on NixOS (LSP servers installed via Nix)
  { "williamboman/mason.nvim", enabled = false },
  { "williamboman/mason-lspconfig.nvim", enabled = false },

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  { import = "nvchad.blink.lazyspec" },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = require("plugins.configs.cmp"),
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      dependencies = {
        {
          "L3MON4D3/LuaSnip",
          dependencies = "rafamadriz/friendly-snippets",
          opts = { history = true, updateevents = "TextChanged,TextChangedI" },
          config = function(_, opts)
            require("plugins.configs.others").luasnip(opts)
          end,
        },

        {
          "windwp/nvim-autopairs",
          opts = {
            fast_wrap = {},
            disable_filetype = { "TelescopePrompt", "vim" },
          },
          config = function(_, opts)
            require("nvim-autopairs").setup(opts)

            local cmp_autopairs = require "nvim-autopairs.completion.cmp"
            require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
          end,
        },
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-emoji",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip",
        "hrsh7th/nvim-cmp",
        "ray-x/cmp-treesitter",
        "js-everts/cmp-tailwind-colors",
        {
          "rcarriga/cmp-dap",
          dependencies = "mfussenegger/nvim-dap",
        },
      }
    },
    opts = function()
      require "plugins.configs.cmp"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    cmd = "Telescope",
    opts = function()
      return require "plugins.configs.telescope"
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },

  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
    ft = "rust",
    config = function ()
	     -- local mason_registry = require('mason-registry')
	     -- local codelldb = mason_registry.get_package("codelldb")
	     -- local extension_path = codelldb:get_install_path() .. "/extension/"
	     -- local codelldb_path = extension_path .. "adapter/codelldb"
	     -- local liblldb_path = extension_path.. "lldb/lib/liblldb.dylib"
	-- -- If you are on Linux, replace the line above with the line below:
	-- -- local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
      local cfg = require('rustaceanvim.config')

      vim.g.rustaceanvim = {
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
    end
  },

  {
    'mfussenegger/nvim-dap',
    config = function()
			local dap, dapui = require("dap"), require("dapui")

      -- dap.adapters.codelldb = {
      --   type = "executable",
      --   command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"
      --
      --   -- On windows you may have to uncomment this:
      --   -- detached = false,
      -- }

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = { "--port", "${port}" },
        }
      }

      dap.configurations.rust = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
      }

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
		end,
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function()
			require("dapui").setup()
		end,
  },

  {
    'saecki/crates.nvim',
    ft = {"toml"},
    config = function()
      require("crates").setup {
        completion = {
          cmp = {
            enabled = true
          },
        },
      }
      require('cmp').setup.buffer({
        sources = { { name = "crates" }}
      })
    end
  },

  {
    "m-demare/hlargs.nvim",
    "nvim-telescope/telescope-media-files.nvim"
  },

  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {}
  },

  {
    "nvim-lua/plenary.nvim",
  },

  {
    'ThePrimeagen/harpoon',
    enabled = true,
    event = require("configs.events").file,
    keys = require("plugins.configs.harpoon").keys,
    opts = require("plugins.configs.harpoon").opts
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  {
    "onsails/lspkind.nvim"
  },

  {
    "tpope/vim-rails",
    event = "VeryLazy"
  },

  {
    "catppuccin/nvim", name = "catppuccin", priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha)
        transparent_background = true
      })
    end
  },


  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      'nvimtools/hydra.nvim',
    },
    opts = {},
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
      {
        mode = { 'v', 'n' },
        '<Leader>m',
        '<cmd>MCstart<cr>',
        desc = 'Create a selection for selected text or word under the cursor',
      },
    },
  },

  {
    "nvimtools/none-ls.nvim",
    config = function()
      require("plugins.configs.null-ls")
    end,
    requires = { "nvim-lua/plenary.nvim" }
  },

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        disable_netrw = true,
        hijack_netrw = true,
        open_on_tab = true,
        hijack_cursor = true,
        update_cwd = true,
        renderer = {
          root_folder_label = false,
          root_folder_modifier = table.concat { ":t:gs?$?/", string.rep(" ", 1000), "?:gs?^??" },
          highlight_opened_files = "all",
          highlight_git = true,
          add_trailing = true,
          special_files = {},
          indent_markers = {
            enable = true,
          },
          icons = {
            glyphs = {
              default = "",
              symlink = "",
              git = {
                deleted = "",
                ignored = "◌",
                renamed = "➜",
                staged = "✓",
                unmerged = "",
                unstaged = "",
                untracked = "",
              },
              folder = {
                arrow_open = "",
                arrow_closed = "",
                default = "",
                empty = "",
                empty_open = "",
                open = "",
                symlink = "",
                symlink_open = "󱧮",
              },
            },
          },
        },
        filters = {
          custom = { ".git", "node_modules" },
        },
        git = {
          enable = true,
          ignore = true,
        },
        update_focused_file = {
          enable = true,
          update_cwd = true,
        },
        view = {
          adaptive_size = true,
          side = "left",
          width = 32,
        },
      }
    end
  }
}
