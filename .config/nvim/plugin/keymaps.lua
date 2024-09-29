vim.api.nvim_create_user_command('Ex', 'Oil', { desc = 'Open file browser' })
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- jj is escape
vim.keymap.set({ 'i' }, 'jj', '<esc>', { silent = true })

-- " Shortcut to edit vimrc
vim.keymap.set({ 'n' }, '<leader>v', ':vsp $MYVIMRC<CR>', { silent = true })

vim.keymap.set({ 'n' }, '<M-P>', ':vsp .', { silent = true })

-- yank deleted to underscore register
vim.keymap.set({ 'x' }, '<leader>p', '"_dP', { silent = true })

-- turn off search highlight
vim.keymap.set({ 'n' }, 'm<leader>', ':nohlsearch<CR>', { silent = true })

-- Apply vim configurations without restarting
vim.keymap.set({ 'n' }, '<leader>r', ':so ~/.config/nvim/init.vim<CR>', { silent = true })

-- Make visual selection searchable with //
vim.keymap.set({ 'v' }, '//', "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>", { silent = true })

-- Move visual selection
vim.keymap.set({ 'v' }, 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set({ 'v' }, 'K', ":m '<-2<CR>gv=gv")

-- vim.keymap.set({ 'n', 'v' }, 'J', '5j', { silent = true })
-- vim.keymap.set({ 'n', 'v' }, 'K', '5k', { silent = true })

-- Static cursor when merging lines
vim.keymap.set({ 'n' }, 'J', 'mzJ`z')

-- Command line navigation
vim.keymap.set({ 'c' }, '<C-e>', '<End>')
vim.keymap.set({ 'c' }, '<C-a>', '<Home>')
vim.keymap.set({ 'c' }, '<C-p>', '<Up>')
vim.keymap.set({ 'c' }, '<C-n>', '<Down>')
vim.keymap.set({ 'c' }, '<C-b>', '<S-Left>')

-- zoom a vim pane, <C-w>= to re-balance
vim.keymap.set({ 'x' }, '<leader>-', ':wincmd _<cr>:wincmd |<cr>', { silent = true })
vim.keymap.set({ 'x' }, '<leader>=', ':wincmd =<cr>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
