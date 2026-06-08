require('telescope').setup({
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
    live_grep_args = {
      auto_quoting = false,
    },
  },
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')
require('telescope').load_extension('live_grep_args')

local builtin = require('telescope.builtin')
local extensions = require('telescope').extensions
local live_grep_args_shortcuts = require('telescope-live-grep-args.shortcuts')

vim.keymap.set('n', '<c-p>', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<c-g>', builtin.git_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', extensions.live_grep_args.live_grep_args, { desc = '[S]earch by [G]rep' })
vim.keymap.set('v', '<leader>sg', live_grep_args_shortcuts.grep_visual_selection, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep({
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  })
end, { desc = '[S]earch [/] in Open Files' })

vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files({ cwd = vim.fn.stdpath('config') })
end, { desc = '[S]earch [N]eovim files' })
