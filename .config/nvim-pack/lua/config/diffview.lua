require('diffview').setup({
  keymaps = {
    view = {
      { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' } },
    },
    file_panel = {
      { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' } },
    },
  },
})

vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Diffview Open' })
vim.keymap.set('n', '<leader>gdd', '<cmd>DiffviewOpen dev<cr>', { desc = 'Diffview against dev' })
