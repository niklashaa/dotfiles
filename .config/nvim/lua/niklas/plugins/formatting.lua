return {
  'stevearc/conform.nvim',
  opts = {
    notify_on_error = false,
    format_on_save = {
      format_after_save = true,
      -- timeout_ms = 500,
      lsp_fallback = true,
    },

    formatters_by_ft = {
      lua = { 'stylua' },
      json = { 'fixjson' },
      -- sql = { 'sqlfmt', 'sql-formatter' },
      yaml = { 'prettierd' },
      markdown = { 'prettierd' },
      -- Sub-list to tell conform to run *until* a formatter is found.
      javascript = { { 'eslint_d', 'prettierd' } },
      vue = { { 'eslint_d', 'prettierd' } },
    },
  },
}
