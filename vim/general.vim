" GENERAL SETTINGS

set nocompatible              " be iMproved, required
filetype off                  " required (vim-sensible)
filetype plugin indent on    " (vim-sensible)

set ruler " shows current row and column in the bottom right
set statusline+=%F " shows current file
" set ttymouse=xterm2
set mouse=a

" Tabs and spaces
set tabstop=2 " number of visual spaces per TAB
set softtabstop=2 " number of spaces in tab when editing
set shiftwidth=2 " governs indentation via >>
set expandtab " tabs are spaces
set smarttab " (vim-sensible)

" UI config
set number
set relativenumber
set wildmode=longest:full,full " Sets autocompletion mode when opening a file in vim
set wildmenu " command line completion
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc
set nocursorline " No highlighting for better scrolling
set lazyredraw " redraw only when we need to.
"set showmatch " highlight matching [{()}]
set autoindent " Don't return to left margin all the time (vim-sensible)
set list "show invisible characters
set listchars=tab:▸\ ,eol:¬,space:·
set showcmd " shows current command
set backspace=indent,eol,start  " more powerful backspacing (vim-sensible)
set title "Show filename
set clipboard=unnamedplus
let python_highlight_all=1 "Make code look pretty

" yank to clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard
  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif

" Plugin shortcuts and settings
let g:netrw_liststyle=3 " Use tree-mode as default view
let g:netrw_preview=1 " preview window shown in a vertically split

" Searching
set path=.,,** " First search in current file, then in current dir, then in every subdirectory
set incsearch " search as characters are entered
set hlsearch " highlight searches ...
let @/ = "" " ... but not when sourcing vimrc
set ignorecase "Be case insensitive when searching
set smartcase " When a search phrase has uppercase, don't be case insensitive

"Colour scheme
syntax enable
set background=dark
colorscheme gruvbox

" Folding
set foldenable "enable folding
set foldmethod=indent " fold based on indent level
set foldlevelstart=10 " open most folds by default
set foldnestmax=10 " 10 nested fold max

" Strip trailing whitespace from all files
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\s\+$//e

au BufRead,BufNewFile,BufReadPost *.json set syntax=json
