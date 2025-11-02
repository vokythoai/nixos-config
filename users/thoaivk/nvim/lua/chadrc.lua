-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
  transparency = true,

  lsp_semantic_tokens = true, -- needs nvim v0.9, just adds highlight groups for lsp semantic tokens
  extended_integrations = {}, -- these aren't compiled by default, ex: "alpha", "notify"


  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

M.ui = {
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "atom_colored", -- default/flat_light/flat_dark/atom/atom_colored
    border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
    selected_item_bg = "colored", -- colored / simple
  },

  telescope = { style = "borderless" }, -- borderless / bordered

  ------------------------------- nvchad_ui modules -----------------------------
  statusline = {
    theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "round",
    overriden_modules = nil,
  },

  -- lazyload it when there are 1+ buffers
  tabufline = {
    show_numbers = true,
    enabled = true,
    lazyload = true,
    overriden_modules = nil,
  },

  cheatsheet = { theme = "grid" }, -- simple/grid

  lsp = {
    -- show function signatures i.e args as you type
    signature = {
      disabled = false,
      silent = true, -- silences 'no signature help available' message from appearing
    },
  },
}

-- Disable Mason on NixOS (use Nix-installed LSP servers instead)
M.mason = {
  enable = false,
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
-- }

return M
