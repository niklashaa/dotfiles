" GENERAL SETTINGS

set nocompatible              " be iMproved, required
filetype off                  " required (vim-sensible)
filetype plugin indent on    " (vim-sensible)

set hidden " show hidden files
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
set smartindent " Smart autoindenting when starting a new line
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

" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
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

"Colour schemes

syntax enable
" light
"set background=light
"colorscheme solarized8
" dark
set background=dark
colorscheme gruvbox

" onedark {{{
"if (has("nvim"))
"  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
"  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"endif
""For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
"" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
"if (has("termguicolors"))
"  set termguicolors
"endif
"syntax on
"colorscheme onedark
" }}}

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
