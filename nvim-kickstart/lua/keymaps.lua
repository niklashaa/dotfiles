-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- ii is escape
vim.keymap.set({ 'i', 'v' }, 'ii', '<esc>', { silent = true })

-- " Shortcut to edit vimrc
vim.keymap.set({ 'n' }, '<leader>v', ':vsp $MYVIMRC<CR>', { silent = true })

-- yank deleted to underscore register
vim.keymap.set({ 'x' }, '<leader>p', '\"_dP', { silent = true })

-- turn off search highlight
vim.keymap.set({ 'n' }, 'm<leader>', ':nohlsearch<CR>', { silent = true })

-- Apply vim configurations without restarting
-- vim.keymap.set({ 'n' }, '<leader>r', ':so ~/.config/nvim/init.vim<CR>', { silent = true })
vim.keymap.set({ 'n' }, '<leader>r', ':so ~/.config/nvim-kickstart/init.lua<CR>', { silent = true })

-- Make visual selection searchable with //
vim.keymap.set({ 'v' }, '//', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>', { silent = true })

-- Move visual selection
vim.keymap.set({ 'v' }, 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set({ 'v' }, 'K', ":m '<-2<CR>gv=gv")

-- vim.keymap.set({ 'n', 'v' }, 'J', '5j', { silent = true })
-- vim.keymap.set({ 'n', 'v' }, 'K', '5k', { silent = true })

-- Static cursor when merging lines
vim.keymap.set({ 'n' }, 'J', 'mzJ`z')

-- Command line navigation
vim.keymap.set({ 'x' }, '<C-a>', '<Home>', { silent = true })
vim.keymap.set({ 'x' }, '<C-e>', '<End>', { silent = true })
vim.keymap.set({ 'x' }, '<C-p>', '<Up>', { silent = true })
vim.keymap.set({ 'x' }, '<C-n>', '<Down>', { silent = true })
vim.keymap.set({ 'x' }, '<C-b>', '<Left>', { silent = true })
vim.keymap.set({ 'x' }, '<C-f>', '<Right>', { silent = true })
vim.keymap.set({ 'x' }, '<M-b>', '<S-Left>', { silent = true })
vim.keymap.set({ 'x' }, '<M-f>', '<S-Right>', { silent = true })

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
