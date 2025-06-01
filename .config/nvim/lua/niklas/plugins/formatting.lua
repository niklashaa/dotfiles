return {
  'stevearc/conform.nvim',
  opts = {
    notify_on_error = false,
    format_on_save = {
      format_after_save = true,
      timeout_ms = 3000,
      lsp_fallback = true,
    },

    formatters_by_ft = {
      lua = { 'stylua' },
      json = { 'fixjson' },
      julia = { 'julials' },
      -- sql = { 'sqlfmt', 'sql-formatter' },
      sql = { 'pg_format' },
      -- yaml = { 'prettierd' },
      markdown = { 'prettierd' },
      html = { 'htmlbeautifier' },
      -- Sub-list to tell conform to run *until* a formatter is found.
      javascript = { 'eslint_d', 'prettierd', stop_after_first = true },
      vue = { 'eslint_d', 'prettierd', stop_after_first = true },
    },
  },
}
