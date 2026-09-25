-- Matches the main config: no custom opts, defaults are fine.
-- setup() registers the :Neotree command and filesystem source.
require('neo-tree').setup({})

vim.keymap.set('n', '<leader>n', '<cmd>Neotree toggle<cr>', { desc = 'Toggle Neo-tree' })
