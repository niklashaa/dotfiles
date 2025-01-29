return {
  -- Interact with multiple databases
  'tpope/vim-dadbod',
  {
    'kristijanhusak/vim-dadbod-ui',
    config = function()
      vim.g.db_ui_save_location = '~/Library/CloudStorage/GoogleDrive-niklas.haag@rizm.de/My Drive/db_ui'
      vim.g.dbs = require 'dadbods' -- Put into nvim/lua/
    end,
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 0
    end,
  },
}
