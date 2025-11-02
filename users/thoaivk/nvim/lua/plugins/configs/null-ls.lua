local null_ls = require("none-ls")

null_ls.setup({
  debug = true,

  sources = {
    -- Javascript & Typescript
    null_ls.builtins.formatting.prettier.with({
      filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "css", "scss", "html", "json", "yaml", "markdown" },
    }),
    null_ls.builtins.diagnostics.eslint_d,

    -----------------
    -- Ruby
    -----------------
    null_ls.builtins.formatting.rubocop,
    null_ls.builtins.diagnostics.rubocop,
    -- null_ls.builtins.formatting.standardrb,
    -- null_ls.builtins.diagnostics.standardrb,

    -- Rust
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.diagnostics.clippy,

    null_ls.builtins.formatting.stylua,  -- Cho Lua
    null_ls.builtins.diagnostics.shellcheck, -- Cho shell scripts
  },

  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = "LspFormat", buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = "LspFormat",
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})
