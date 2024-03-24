return {
  -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.

  -- { 'navarasu/onedark.nvim', name = "onedark" },
  -- { "folke/tokyonight.nvim", name = "tokyonight", }
  -- { "rose-pine/neovim", name = "rose-pine" },
  -- { "bluz71/vim-nightfly-colors", name = "nightfly" },
  -- { "catppuccin/nvim", name = "catppuccin" }
  "ellisonleao/gruvbox.nvim",
  priority = 1000, -- Make sure to load this before all the other start plugins.
  lazy = false,
  name = "gruvbox",
  init = function()
    vim.cmd.colorscheme 'gruvbox'
    -- You can configure highlights by doing something like:
    vim.cmd.hi 'Comment gui=none'
  end,
}
