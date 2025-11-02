require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "clangd",
  "rust_analyzer",
  "gopls",
  "solargraph",
  "pyright",
}

vim.lsp.enable(servers)

-- Format on save for Rust, Go, and Ruby
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.rs", "*.go", "*.rb" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Rust-specific settings
vim.lsp.config.rust_analyzer = {
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  },
}

-- Go-specific settings
vim.lsp.config.gopls = {
  settings = {
    gopls = {
      gofumpt = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}

-- Ruby-specific settings
vim.lsp.config.solargraph = {
  settings = {
    solargraph = {
      diagnostics = true,
      formatting = true,
    },
  },
} 
