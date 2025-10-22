-- Repos for comparison
-- https://github.com/josean-dev/dev-environment-files/tree/main/.config/nvim
-- https://github.com/dmmulroy/kickstart.nix/tree/main/config/nvim

-- Using a namespaced folder for plugins like plugins/niklas avoids namespacing issues
-- For instance having a treesitter config file named 'treesitter.lua' in your lua directory may cause issues
-- as the 'treesitter' namespace is already in use by the treesitter plugin.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
require('lazy').setup({
  'tpope/vim-fugitive', -- Git related plugins
  -- 'tpope/vim-rhubarb',
  -- 'tpope/vim-sensible',
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'tpope/vim-unimpaired', -- Move between warnings/errors
  'tpope/vim-surround', -- Mappings for surroundings like brackets, quotes, e.t.c.
  'tpope/vim-repeat', -- Repeat for vim-surround and other packages
  'christoomey/vim-tmux-navigator', -- Send commands from vim to tmux
  'christoomey/vim-tmux-runner',
  'JuliaEditorSupport/julia-vim',
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {}, lazy = false },
  { import = 'niklas.plugins' },

  -- Things to try out:
  -- 'github/copilot.vim'

  -- Note taking
  -- 'nvim-neorg/neorg',
  -- Tutorial: https://www.youtube.com/watch?v=NnmRVY22Lq8
  --
  -- markdown preview
  -- 'iamcco/markdown-preview.nvim',
  --
  -- Docker alternative
  -- https://github.com/abiosoft/colima
  --
  -- Harpoon
  -- 'ThePrimeagen/harpoon'
  --
  -- Expand region
  -- https://github.com/terryma/vim-expand-region
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table
    icons = {},
  },
  change_detection = {
    notify = false, -- Disable "Config Change Detected. Reloading..." notification
  },
})

-- [[ automatically rebalance windows on vim resize ]]
vim.api.nvim_create_autocmd('VimResized', {
  pattern = { '*' },
  command = ':wincmd =',
})

-- [[ Strip trailing whitespace from all files ]]
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*' },
  command = [[%s/\s\+$//e]],
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
