" Niklas' init.vim
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" General plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'christoomey/vim-tmux-navigator'
" Plugin 'scrooloose/nerdtree'
" Plugin 'itchyny/lightline.vim'
Plugin 'kien/ctrlp.vim'
" assuming you're using vim-plug: https://github.com/junegunn/vim-plug
Plugin 'ncm2/ncm2'
Plugin 'roxma/nvim-yarp'
" NOTE: you need to install completion sources to get completions. Check
" our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
Plugin 'ncm2/ncm2-bufword'
Plugin 'ncm2/ncm2-path'

" Mixed specific plugins
" Plugin 'davidhalter/jedi-vim'
Plugin 'tpope/vim-surround'
Plugin 'mattn/emmet-vim'
" Plugin 'JuliaEditorSupport/julia-vim'
Plugin 'posva/vim-vue'
Plugin 'maksimr/vim-jsbeautify'

call vundle#end()            " required
filetype plugin indent on    " required

" Plugin shortcuts and settings
"map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore .pyc files in NERDTree
let python_highlight_all=1 "Make code look pretty
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_max_files=0
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc
let g:user_emmet_mode='a'
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
let g:user_emmet_expandabbr_key = '<C-y>m'

map <c-f> :call JsBeautify()<cr>

" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect
" use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" General settings
let mapleader=','
nnoremap <C-a> <C-w>
" jk is escape
inoremap jk <esc>
vnoremap jk <esc>
set ruler " shows current row and column in the bottom right
set statusline+=%F " shows current file
" set ttymouse=xterm2
set mouse=a
" command! MakeTags !ctags -R .

" Tabs and spaces
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set shiftwidth=4 " governs indentation via >>
set expandtab " tabs are spaces
set smarttab

" UI config
set number
set relativenumber
set wildmode=longest:full,full " Sets autocompletion mode when opening a file in vim
set wildmenu " command line completion
set nocursorline " No highlighting for better scrolling
set lazyredraw " redraw only when we need to.
"set showmatch " highlight matching [{()}]
set autoindent " Don't return to left margin all the time
set list "show invisible characters
set listchars=tab:▸\ ,eol:¬,space:·
set showcmd " shows current command
set backspace=indent,eol,start  " more powerful backspacing
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
colorscheme molokai

" Folding
set foldenable "enable folding
set foldmethod=indent " fold based on indent level
set foldlevelstart=10 " open most folds by default
set foldnestmax=10 " 10 nested fold max

" Split + remap moving between panes
set splitbelow
set splitright
