" GENERAL SETTINGS

set nocompatible              " be iMproved, required
set termguicolors " enable 24-bit TUI colours
syntax enable
filetype off                  " required (vim-sensible)
filetype plugin indent on    " (vim-sensible)

" nvim defaults https://neovim.io/doc/user/vim_diff.html#nvim-defaults
" set hidden " show hidden files
" set ruler " shows current row and column in the bottom right
" set smarttab " (vim-sensible)
" set wildmenu " command line completion
" set incsearch " search as characters are entered
" set hlsearch " highlight searches
" set showcmd " shows current command

set statusline+=%F " shows current file
" set ttymouse=xterm2
set mouse=a

" Tabs and spaces
set tabstop=2 " number of visual spaces per TAB
set softtabstop=2 " number of spaces in tab when editing
set shiftwidth=2 " governs indentation via >>
set expandtab " tabs are spaces

" UI config
set number
set relativenumber
set wildmode=longest:full,full " Sets autocompletion mode when opening a file in vim
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc
set nocursorline " No highlighting for better scrolling
set lazyredraw " redraw only when we need to.
"set showmatch " highlight matching [{()}]
set autoindent " Don't return to left margin all the time (vim-sensible)
set smartindent " Smart autoindenting when starting a new line
set list "show invisible characters
set listchars=tab:▸\ ,eol:¬,space:·
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
  " autocmd bufwritepost general.vim source ~/.config/nvim/init.vim
  " autocmd bufwritepost mappings.vim source $MYVIMRC
  " autocmd bufwritepost plugin_list.vim source $MYVIMRC
  " autocmd bufwritepost plugin_settings.vim source $MYVIMRC
endif

" Plugin shortcuts and settings
let g:netrw_liststyle=3 " Use tree-mode as default view
let g:netrw_preview=1 " preview window shown in a vertically split

" Searching
" https://twitter.com/tpope/status/612991667751264256
set path=.,,node_modules " Search in current file, then in current dir, then following dirs
" https://github.com/tpope/vim-apathy
set includeexpr=substitute(v:fname,'^\\~\/','${PWD}/','') " substitute tilde with current working dir
set suffixesadd=.vue,.js,.ts " Let gf also find these files
let @/ = "" " No hlsearch when when sourcing vimrc
set ignorecase "Be case insensitive when searching
set smartcase " When a search phrase has uppercase, don't be case insensitive

" The Silver Searcher
" https://thoughtbot.com/blog/faster-grepping-in-vim
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
  " nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

  " bind \ (backward slash) to grep shortcut
  command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
  nnoremap \ :Ag<SPACE>
  nnoremap <leader>s :Ag<SPACE>
endif

" Folding
set foldenable "enable folding
set foldmethod=indent " fold based on indent level
set foldlevelstart=10 " open most folds by default
set foldnestmax=10 " 10 nested fold max

" Strip trailing whitespace from all files
autocmd BufWritePre * %s/\s\+$//e

au BufRead,BufNewFile,BufReadPost *.json set syntax=json

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>
