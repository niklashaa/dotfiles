return {
  -- Interact with multiple databases
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    'tpope/vim-dadbod', -- Interact with databases
  },
  config = function()
    vim.g.db_ui_save_location = '~/Library/CloudStorage/GoogleDrive-niklas.haag@kerith.net/My Drive/db_ui'
    vim.g.dbs = require 'dadbods'
  end,
}
