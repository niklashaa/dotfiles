" Niklas' init.vim
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" General plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'scrooloose/nerdtree'
Plugin 'itchyny/lightline.vim'
Plugin 'kien/ctrlp.vim'

" Mixed specific plugins
Plugin 'mechatroner/rainbow_csv'
Plugin 'LnL7/vim-nix'
Plugin 'tpope/vim-surround'
Plugin 'mattn/emmet-vim'
Plugin 'JuliaEditorSupport/julia-vim'
Plugin 'posva/vim-vue'
call vundle#end()            " required
filetype plugin indent on    " required

" General settings
let mapleader=','
" jk is escape
inoremap jk <esc>
vnoremap jk <esc>
set ruler " shows current row and column in the bottom right
set statusline+=%F " shows current file
" set ttymouse=xterm2
set mouse=a
command! MakeTags !ctags -R .

" Tabs and spaces
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set shiftwidth=4 " governs indentation via >>
set expandtab " tabs are spaces
set smarttab
" remap stripping function to f5
nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>
nnoremap <C-a> <C-w>

" UI config
set number
set relativenumber
set wildmode=full " Sets autocompletion mode when opening a file in vim
set wildmenu " command line completion
set nocursorline " No highlighting for better scrolling
set lazyredraw " redraw only when we need to.
set showmatch " highlight matching [{()}]
set autoindent " Don't return to left margin all the time
set clipboard=unnamed
set list "show invisible characters
set listchars=tab:▸\ ,eol:¬,space:·
set showcmd " shows current command
set backspace=indent,eol,start  " more powerful backspacing
set title "Show filename
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
colorscheme molokai

" Folding
set foldenable "enable folding
set foldmethod=indent " fold based on indent level
set foldlevelstart=10 " open most folds by default
set foldnestmax=10 " 10 nested fold max

" Split + remap moving between panes
set splitbelow
set splitright

" Functions
function! StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunc

" toggle between number and relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc
