" KEYMAP SETTINGS

let mapleader=','

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
nnoremap ,<leader> :nohlsearch<CR>

" Live substitution
set inccommand=split

" Split + remap moving between panes
set splitbelow
set splitright

" Apply vim configurations without restarting
nnoremap <Leader>r :so ~/.config/nvim/init.vim<CR>

" Shortcut to edit vimrc
nmap <leader>v :tabedit $MYVIMRC<CR>

" Make visual selection searchable with //
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" Save state of open Windows and Buffers
" nnoremap <leader>s :mksession<CR>

