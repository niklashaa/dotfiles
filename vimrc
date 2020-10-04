" Niklas' .vimrc
set nocompatible              " be iMproved, required
"filetype off                  " required (vim-sensible)

call plug#begin()
"General plugins
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'

" Mixed specific plugins
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'mattn/emmet-vim'
" Plug 'JuliaEditorSupport/julia-vim'
Plug 'posva/vim-vue'
Plug 'maksimr/vim-jsbeautify'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()            " required
filetype plugin indent on "(vim-sensible)

" Plugin shortcuts and settings
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore .pyc files in NERDTree

let g:netrw_liststyle=3 " Use tree-mode as default view
let g:netrw_browse_split=4 " Open file in previous buffer
let g:netrw_preview=1 " preview window shown in a vertically split
autocmd BufWritePre *
    \ if '<afile>' !~ '^scp:' && !isdirectory(expand('<afile>:h')) |
        \ call mkdir(expand('<afile>:h'), 'p') |
    \ endif
let python_highlight_all=1 "Make code look pretty
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_max_files=0
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc
let g:user_emmet_mode='a'
let g:user_emmet_install_global = 0
let g:user_emmet_leader_key='<c-s>'
autocmd FileType html,css,vue EmmetInstall

map <c-f> :call JsBeautify()<cr>
let g:deoplete#enable_at_startup = 1

" General settings
"let mapleader=','
" ii is escape
inoremap ii <esc>
vnoremap ii <esc>
set ruler " shows current row and column in the bottom right
set statusline+=%F " shows current file
" set ttymouse=xterm2
set mouse=a
"command! MakeTags !ctags -R .

" Tabs and spaces
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set shiftwidth=4 " governs indentation via >>
set expandtab " tabs are spaces
set smarttab " (vim-sensible)

" UI config
set number
set relativenumber
set wildmode=longest:full,full " Sets autocompletion mode when opening a file in vim
set wildmenu " command line completion
set nocursorline " No highlighting for better scrolling
set lazyredraw " redraw only when we need to.
"set showmatch " highlight matching [{()}]
set autoindent " Don't return to left margin all the time (vim-sensible)
set list "show invisible characters
set listchars=tab:▸\ ,eol:¬,space:·
set showcmd " shows current command
set backspace=indent,eol,start  " more powerful backspacing (vim-sensible)
set title "Show filename
set clipboard=unnamed
" yank to clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard
  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif
noremap <Leader>y "*y
noremap <Leader>p "*p

" Searching
set path=.,,** " First search in current file, then in current dir, then in every subdirectory
set incsearch " search as characters are entered
set hlsearch " highlight searches ...
let @/ = "" " ... but not when sourcing vimrc
set ignorecase "Be case insensitive when searching
set smartcase " When a search phrase has uppercase, don't be case insensitive
" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

"Colorscheme
syntax enable
set background=dark
colorscheme gruvbox

" Folding
set foldenable "enable folding
set foldmethod=indent " fold based on indent level
set foldlevelstart=10 " open most folds by default
set foldnestmax=10 " 10 nested fold max

" Split + remap moving between panes
set splitbelow
set splitright
