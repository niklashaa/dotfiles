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
  -- Some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  -- 'tpope/vim-rhubarb',

  -- 'tpope/vim-sensible',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Move between warnings/errors
  'tpope/vim-unimpaired',

  -- Mappings for surroundings like brackets, quotes, e.t.c.
  'tpope/vim-surround',

  -- Repeat for vim-surround and other packages
  'tpope/vim-repeat',

  'christoomey/vim-tmux-navigator',
  -- Send commands from vim to tmux
  'christoomey/vim-tmux-runner',

  -- 'github/copilot.vim'

  -- Interact with databases
  'tpope/vim-dadbod',
  -- Interact with multiple databases
  'kristijanhusak/vim-dadbod-ui',

  'JuliaEditorSupport/julia-vim',

  -- Things to try out:
  -- Not taking
  -- 'nvim-neorg/neorg',
  -- Tutorial: https://www.youtube.com/watch?v=NnmRVY22Lq8
  --
  -- explorer
  -- 'stevearc/oil.nvim',
  --
  -- markdown preview
  -- 'iamcco/markdown-preview.nvim',
  --
  -- Tiling window manager
  -- https://github.com/koekeishiya/yabai?tab=readme-ov-file
  --
  -- Docker alternative
  -- https://github.com/abiosoft/colima
  --
  -- Harpoon
  -- 'ThePrimeagen/harpoon'

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',  opts = {} },

  -- { import = 'kickstart.plugins' },
  { import = 'niklas.plugins' },
}, {})

require("options")
require("keymaps")

-- [[ automatically rebalance windows on vim resize ]]
vim.api.nvim_create_autocmd('VimResized', {
  pattern = { "*" },
  command = ":wincmd =" }
)

-- [[ Strip trailing whitespace from all files ]]
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  -- completion = {
  --   completeopt = 'menu,menuone,noinsert',
  -- },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<c-y>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },

    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
