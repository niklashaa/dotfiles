require('neogit').setup({
  kind = 'tab',
})

vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Neogit' })
vim.keymap.set('n', '<leader>g-', '<cmd>Git checkout -<cr>', { desc = 'Checkout previous branch' })
