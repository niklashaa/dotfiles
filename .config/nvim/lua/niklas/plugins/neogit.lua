return {
  'NeogitOrg/neogit',
  keys = {
    { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neogit' },
    { '<leader>g-', '<cmd>Git checkout -<cr>', desc = 'Checkout previous branch' },
  },
  opts = {
    kind = 'replace',
  },
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- Diff integration (configured in diffview.lua)

    -- Only one of these is needed.
    'nvim-telescope/telescope.nvim', -- optional
    -- 'ibhagwan/fzf-lua', -- optional
    -- 'nvim-mini/mini.pick', -- optional
    -- 'folke/snacks.nvim', -- optional
  },
}
