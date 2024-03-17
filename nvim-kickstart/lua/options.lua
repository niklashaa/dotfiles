-- Tabs and spaces
vim.o.tabstop = 2      -- number of visual spaces per TAB
vim.o.softtabstop = 2  -- number of spaces in tab when editing
vim.o.shiftwidth = 2   -- governs indentation via >>
vim.o.expandtab = true -- tabs are spaces

-- Set highlight on search
vim.o.hlsearch = true
vim.o.incsearch = true

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Show invisible characters
vim.wo.list = true
vim.wo.listchars = 'tab:▸ ,eol:¬,space:·'

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 50
vim.o.timeoutlen = 300

vim.o.scrolloff = 1

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
vim.o.splitbelow = true
vim.o.splitright = true

-- Live substitution
vim.o.inccommand = 'split'
