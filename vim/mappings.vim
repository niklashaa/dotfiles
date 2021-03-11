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

" Copy and paste to the system clipboard
noremap <Leader>y "*y
noremap <Leader>d "*d
noremap <Leader>p "*p
noremap <Leader>P "*P
vnoremap <C-c> "*y

" turn off search highlight
nnoremap ,<leader> :nohlsearch<CR>

" Live substitution
set inccommand=split

" Split + remap moving between panes
set splitbelow
set splitright

" Save state of open Windows and Buffers
nnoremap <leader>s :mksession<CR>

" Find tags with CtrlP
nnoremap <Leader>t :CtrlPBufTag<CR>
nnoremap <Leader>T :CtrlPTag<CR>

" Apply vim configurations without restarting
nnoremap <Leader>r :so ~/.config/nvim/init.vim<CR>

" Save state of open Windows and Buffers
" nnoremap <leader>s :mksession<CR>
