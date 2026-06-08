require('conform').setup({
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
    javascript = { 'eslint_d' },
    typescript = { 'eslint_d' },
    vue = { 'eslint_d' },
  },
})
