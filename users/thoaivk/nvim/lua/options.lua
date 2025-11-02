require "nvchad.options"

-- add yours here!

local opt = vim.opt

-- Clipboard configuration
-- Use system clipboard for yank/paste operations
opt.clipboard = "unnamedplus"

-- Enable mouse support
opt.mouse = "a"

-- OSC 52 clipboard configuration (copy only, no paste)
-- This copies from NixOS VM to macOS clipboard via OSC 52 escape sequences
local function osc52_copy(lines, _)
  require("vim.ui.clipboard.osc52").copy("+")(lines)
end

-- Use system register for pasting (you paste with Cmd+V on macOS)
local function fallback_paste()
  -- Don't try to paste via OSC 52, use local register
  return vim.fn.getreg('+'), vim.fn.getregtype('+')
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = osc52_copy,
    ["*"] = osc52_copy,
  },
  paste = {
    ["+"] = fallback_paste,
    ["*"] = fallback_paste,
  },
}

-- Disable paste query timeout (prevents "waiting for OSC 52" message)
vim.g.clipboard_query_wait = 0

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
