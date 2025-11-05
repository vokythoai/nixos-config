require "nvchad.options"

-- add yours here!

local opt = vim.opt

-- Clipboard configuration for SSH + tmux environments
-- Use system clipboard for yank/paste operations
opt.clipboard = "unnamedplus"

-- Check if running inside tmux or via SSH
local in_tmux = vim.env.TMUX ~= nil
local in_ssh = vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_TTY ~= nil

-- Detect if running on a system with display server (local machine)
local has_display = false
if vim.fn.has("mac") == 1 then
  has_display = true -- macOS always has display
elseif vim.fn.has("wsl") == 1 then
  has_display = true -- WSL can access Windows clipboard
else
  -- Linux: check for X11 or Wayland
  local has_wayland = vim.fn.getenv("WAYLAND_DISPLAY") ~= vim.NIL and vim.fn.getenv("WAYLAND_DISPLAY") ~= ""
  local has_x11 = vim.fn.getenv("DISPLAY") ~= vim.NIL and vim.fn.getenv("DISPLAY") ~= ""
  has_display = has_wayland or has_x11
end

-- For SSH/tmux environments (like SSH to NixOS VM), use OSC 52 + tmux
-- OSC 52 is a terminal escape sequence that allows clipboard access without X11/Wayland
if in_ssh or (in_tmux and not has_display) then
  if in_tmux then
    -- When inside tmux, use tmux clipboard provider with OSC 52
    -- Copy: Use tmux load-buffer -w which sends OSC 52 to the terminal
    -- Paste: Use tmux refresh-client -l to fetch clipboard, then save-buffer to paste
    local copy = { "tmux", "load-buffer", "-w", "-" }
    local paste = { "bash", "-c", "tmux refresh-client -l && sleep 0.05 && tmux save-buffer -" }

    vim.g.clipboard = {
      name = "tmux with OSC 52",
      copy = {
        ["+"] = copy,
        ["*"] = copy,
      },
      paste = {
        ["+"] = paste,
        ["*"] = paste,
      },
      cache_enabled = 0,
    }
  else
    -- Not in tmux, use pure OSC 52
    vim.g.clipboard = {
      name = "OSC 52",
      copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
      },
      paste = {
        ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
        ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
      },
    }
  end
-- For local systems with display servers, use traditional clipboard tools
elseif vim.fn.has("mac") == 1 then
  -- macOS: use pbcopy/pbpaste
  vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = {
      ["+"] = "pbcopy",
      ["*"] = "pbcopy",
    },
    paste = {
      ["+"] = "pbpaste",
      ["*"] = "pbpaste",
    },
    cache_enabled = 0,
  }
elseif vim.fn.has("wsl") == 1 then
  -- WSL: use Windows clipboard
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
else
  -- Linux with display server: use appropriate clipboard tool
  local has_wayland = vim.fn.getenv("WAYLAND_DISPLAY") ~= vim.NIL and vim.fn.getenv("WAYLAND_DISPLAY") ~= ""
  local has_x11 = vim.fn.getenv("DISPLAY") ~= vim.NIL and vim.fn.getenv("DISPLAY") ~= ""

  if has_wayland and vim.fn.executable("wl-copy") == 1 then
    vim.g.clipboard = {
      name = "wl-clipboard",
      copy = {
        ["+"] = "wl-copy",
        ["*"] = "wl-copy",
      },
      paste = {
        ["+"] = "wl-paste --no-newline",
        ["*"] = "wl-paste --no-newline",
      },
      cache_enabled = 0,
    }
  elseif has_x11 and vim.fn.executable("xclip") == 1 then
    vim.g.clipboard = {
      name = "xclip",
      copy = {
        ["+"] = "xclip -selection clipboard",
        ["*"] = "xclip -selection primary",
      },
      paste = {
        ["+"] = "xclip -selection clipboard -o",
        ["*"] = "xclip -selection primary -o",
      },
      cache_enabled = 0,
    }
  elseif has_x11 and vim.fn.executable("xsel") == 1 then
    vim.g.clipboard = {
      name = "xsel",
      copy = {
        ["+"] = "xsel --clipboard --input",
        ["*"] = "xsel --primary --input",
      },
      paste = {
        ["+"] = "xsel --clipboard --output",
        ["*"] = "xsel --primary --output",
      },
      cache_enabled = 0,
    }
  else
    -- No display server and not SSH: fallback to OSC 52
    vim.g.clipboard = {
      name = "OSC 52 fallback",
      copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
      },
      paste = {
        ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
        ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
      },
    }
  end
end

-- Enable mouse support
opt.mouse = "a"

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
