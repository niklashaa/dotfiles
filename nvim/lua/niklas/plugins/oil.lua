-- https://github.com/stevearc/oil.nvim/pull/237
vim.api.nvim_create_user_command('Ex', 'Oil', { desc = 'Open file browser' })
vim.api.nvim_create_user_command('VEx', function()
  vim.cmd 'vsplit | wincmd l'
  require('oil').open()
end, { desc = 'Open file browser in vertical split' })
vim.api.nvim_create_user_command('HEx', function()
  vim.cmd 'split | wincmd j'
  require('oil').open()
end, { desc = 'Open file browser in vertical split' })

return {
  'stevearc/oil.nvim',
  opts = {
    default_file_explorer = true,
    columns = { 'icon' },
    keymaps = {
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.select',
      ['<C-v>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
      ['<C-h>'] = false,
      ['<M-h>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
      ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = 'actions.close',
      ['<C-l>'] = false, -- ['<C-l>'] = 'actions.refresh',
      ['-'] = 'actions.parent',
      ['_'] = 'actions.open_cwd',
      ['`'] = 'actions.cd',
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory' },
      ['gs'] = 'actions.change_sort',
      ['gx'] = 'actions.open_external',
      ['g.'] = 'actions.toggle_hidden',
      ['g\\'] = 'actions.toggle_trash',
    },
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
    },
  },
  -- Optional dependencies
  -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if prefer nvim-web-devicons
}
