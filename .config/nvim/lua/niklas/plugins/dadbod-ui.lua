return {
  -- Interact with multiple databases
  'tpope/vim-dadbod',
  {
    'kristijanhusak/vim-dadbod-ui',
    config = function()
      vim.g.db_ui_save_location = '~/Library/CloudStorage/GoogleDrive-niklas.haag@kerith.net/My Drive/db_ui'
      vim.g.dbs = require 'dadbods'
    end,
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 0
    end,
  },
}
