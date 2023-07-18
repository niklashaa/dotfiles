call plug#begin()
" General plugins
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary' " Easy commenting
Plug 'JoosepAlviste/nvim-ts-context-commentstring' " Set commentstring option based on cursor location in the file, using treesitter
Plug 'tpope/vim-unimpaired' " Move between warnings/errors
Plug 'tpope/vim-fugitive' " Git wrapper
Plug 'tpope/vim-surround' " Mappings for surroundings like brackets, quotes, e.t.c.
Plug 'tpope/vim-repeat' " Repeat for vim-surround and other packages

Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner' " Send commands from vim to tmux
" Plug 'github/copilot.vim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " We recommend updating the parsers on update
Plug 'neoclide/coc.nvim', {'branch': 'release'} "IDE like features
Plug 'ctrlpvim/ctrlp.vim' " Fuzzy search
Plug 'ludovicchabant/vim-gutentags' " Manage tag files automatically
Plug 'dense-analysis/ale' " Asynchronous Lint Engine
Plug 'leafOfTree/vim-vue-plugin'
Plug 'mbbill/undotree' " Vim undo tree vizualizer
Plug 'itchyny/lightline.vim'

" Specific plugins
Plug 'mattn/emmet-vim' " Makes writing HTML and CSS much easier
Plug 'maksimr/vim-jsbeautify' " beautifies on <C-f>
Plug 'junegunn/rainbow_parentheses.vim' " Highlight matching parantheses
Plug 'tpope/vim-dadbod' " Interact with databases
Plug 'kristijanhusak/vim-dadbod-ui' " Interact with multiple databases
Plug 'mechatroner/rainbow_csv' " rainbow csv
Plug 'JuliaEditorSupport/julia-vim'
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

" Colorschemes
Plug 'ellisonleao/gruvbox.nvim'
" Plug 'morhetz/gruvbox'

Plug 'sainnhe/gruvbox-material'
" Plug 'joshdick/onedark.vim'
" Plug 'dracula/vim'
" Plug 'folke/tokyonight.nvim'
" Plug 'jacoborus/tender.vim'
" Plug 'savq/melange'
" Plug 'sainnhe/edge'
" Plug 'mhartington/oceanic-next'
" Plug 'mcchrish/zenbones.nvim'
" Plug 'patstockwell/vim-monokai-tasty'
" Plug 'luisiacc/gruvbox-baby'

call plug#end()            " required
