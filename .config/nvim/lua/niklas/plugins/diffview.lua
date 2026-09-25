return {
  'sindrets/diffview.nvim',
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diffview Open' },
    { '<leader>gdd', '<cmd>DiffviewOpen dev<cr>', desc = 'Diffview against dev' },
    { '<leader>gdm', '<cmd>DiffviewOpen main<cr>', desc = 'Diffview against main' },
  },
  opts = {
    keymaps = {
      view = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' } },
        -- shorter than the default <C-w>gf, which times out at timeoutlen=300
        { 'n', '<C-t>', '<cmd>lua require("diffview.actions").goto_file_tab()<cr>', { desc = 'Open the file in a new tab' } },
      },
      file_panel = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' } },
        { 'n', '<C-t>', '<cmd>lua require("diffview.actions").goto_file_tab()<cr>', { desc = 'Open the file in a new tab' } },
      },
    },
  },
}
