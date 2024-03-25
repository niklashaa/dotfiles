" KEYMAP SETTINGS

let mapleader=' '

" ii is escape
inoremap ii <esc>
vnoremap ii <esc>
noremap gj J

" Move down file lines
noremap J 5j
vnoremap J 5j
" Move up file lines
noremap K 5k
vnoremap K 5k

" yank deleted to underscore register
xnoremap ("<leader>p", "\"_dP")

" turn off search highlight
nnoremap m<leader> :nohlsearch<CR>

" Live substitution
set inccommand=split

" Split + remap moving between panes
set splitbelow
set splitright

" Apply vim configurations without restarting
nnoremap <Leader>r :so ~/.config/nvim/init.vim<CR>

" Open file under cursor in vertical split
nnoremap <C-W>f <C-W>vgf

" Shortcut to edit vimrc
nmap <leader>v :vsp $MYVIMRC<CR>

" Make visual selection searchable with //
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" Save state of open Windows and Buffers
" nnoremap <leader>s :mksession<CR>

" Command line navigation
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

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

