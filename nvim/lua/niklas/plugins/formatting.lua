return {
  'stevearc/conform.nvim',
  opts = {
    notify_on_error = false,
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },

    formatters_by_ft = {
      lua = { 'stylua' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      -- Sub-list to tell conform to run *until* a formatter is found.
      javascript = { { 'eslint_d', 'prettierd', 'prettier' } },
      vue = { { 'eslint_d', 'prettierd', 'prettier' } },
    },
  },
}
