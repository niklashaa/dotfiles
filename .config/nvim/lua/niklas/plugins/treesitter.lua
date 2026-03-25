-- See `:help nvim-treesitter`
return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  opts = {
    ensure_installed = {
      -- 'c', 'cpp', 'go', 'rust', 'nix',
      'bash',
      'css',
      'gitcommit',
      'html',
      'hurl',
      'json',
      'javascript',
      'julia',
      'lua',
      'markdown',
      'python',
      'sql',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'vue',
    },
    -- Autoinstall languages that are not installed
    auto_install = false,
    highlight = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts)
    require('nvim-treesitter.install').prefer_git = true
    require('nvim-treesitter').setup(opts)
  end,
}
