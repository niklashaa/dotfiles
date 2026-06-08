-- Experimental Neovim config using the built-in plugin manager (vim.pack, Neovim 0.12+).
-- Isolated from the main config — launch with:  NVIM_APPNAME=nvim-pack nvim
-- Built up from scratch to benchmark startup vs the lazy.nvim setup.

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false

-- Byte-compile cache for Lua modules. This is the main startup win and the
-- reason eager-loading under vim.pack can stay competitive with lazy.nvim.
vim.loader.enable()

-- Build hooks. vim.pack has no `build` field — instead you listen for PackChanged.
-- Build steps keyed by plugin name; dispatched from the PackChanged autocmd below.
-- Adding a build step is one table entry, not a new control-flow branch.
local build = {
  ['telescope-fzf-native.nvim'] = function(path)
    vim.notify('vim.pack: building telescope-fzf-native…')
    vim.system({ 'make' }, { cwd = path }):wait()
  end,
  ['LuaSnip'] = function(path)
    vim.notify('vim.pack: building LuaSnip jsregexp…')
    vim.system({ 'make', 'install_jsregexp' }, { cwd = path }):wait()
  end,
  ['nvim-treesitter'] = function()
    -- main branch: recompile/update installed parsers after a plugin update.
    vim.schedule(function()
      pcall(function()
        require('nvim-treesitter').update()
      end)
    end)
  end,
}

-- This autocmd MUST be registered BEFORE any vim.pack.add() (including the deferred
-- ones in lua/config/*) so it fires whenever a plugin is first installed.
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack-build', { clear = true }),
  callback = function(ev)
    local d = ev.data
    if d.kind ~= 'install' and d.kind ~= 'update' then
      return
    end
    local hook = build[d.spec.name]
    if hook then
      hook(d.path)
    end
  end,
})

-- EAGER plugins: needed at startup (colorscheme, statusline, highlighting), cheap
-- vimscript, shared deps, or things that attach to file open. One add() call.
vim.pack.add({
  -- colorscheme (first, replaces lazy's priority=1000)
  { src = 'https://github.com/ellisonleao/gruvbox.nvim', name = 'gruvbox' },

  -- shared dependencies, listed once before anything that needs them
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/MunifTanjim/nui.nvim',

  -- vimscript / tpope set (cheap, not worth deferring)
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-sleuth',
  'https://github.com/tpope/vim-unimpaired',
  'https://github.com/tpope/vim-surround',
  'https://github.com/tpope/vim-repeat',
  'https://github.com/christoomey/vim-tmux-navigator',
  'https://github.com/christoomey/vim-tmux-runner',
  'https://github.com/JuliaEditorSupport/julia-vim',
  'https://github.com/numToStr/Comment.nvim',

  -- treesitter — `main` branch: the `master` branch is frozen and does NOT
  -- support Neovim 0.12. `main` is the actively-maintained rewrite (new API).
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },

  -- fuzzy finder
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope-live-grep-args.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',

  -- LSP stack (mason → mason-lspconfig → lspconfig)
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/folke/lazydev.nvim',

  -- completion (LuaSnip has a build hook; see PackChanged above)
  { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range('2.x') },
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/saadparwaiz1/cmp_luasnip',
  'https://github.com/hrsh7th/cmp-buffer',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-path',
  'https://github.com/kristijanhusak/vim-dadbod-completion',
  'https://github.com/hrsh7th/nvim-cmp',

  -- git
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/sindrets/diffview.nvim', -- also a neogit dep
  'https://github.com/NeogitOrg/neogit',

  -- database
  'https://github.com/tpope/vim-dadbod',
  'https://github.com/kristijanhusak/vim-dadbod-ui',

  -- editor
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = 'v3.x' },
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/mbbill/undotree',
  'https://github.com/supermaven-inc/supermaven-nvim',
})

-- Colorscheme (was lazy's `init`)
vim.cmd.colorscheme('gruvbox')
vim.cmd.hi('Comment gui=none')

-- Per-plugin setup. Complicated plugins live in their own files under lua/config/.
require('Comment').setup({})
require('config.treesitter')
require('config.telescope')
require('config.lsp')
require('config.cmp')
require('config.oil')
require('config.gitsigns')
require('config.diffview')
require('config.neogit')
require('config.dadbod')
require('config.lualine')
require('config.conform')
require('config.neotree')
require('config.supermaven')
require('config.undotree')

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

-- [[ Treat .env.* files as dotenv with bash syntax highlighting ]]
vim.filetype.add({
  pattern = {
    ['%.env%..*'] = 'dotenv',
  },
})
vim.treesitter.language.register('bash', 'dotenv')
