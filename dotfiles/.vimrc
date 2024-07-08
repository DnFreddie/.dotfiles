set mouse=a

let mapleader = " "
nnoremap <leader><Space> :Explore<CR>

" enable syntax "
syntax on
set incsearch
" enable line numbers "

" highlight current line "
"enable highlight search pattern "

" enable smartcase search sensitivity "
set ignorecase
set smartcase
set undofile
let &undodir = expand('$HOME/.vim/undodir_vim')
set signcolumn=yes
set smartcase
set updatetime=25
set relativenumber

" Indentation using spaces "
" tabstop:	width of tab character
" softtabstop:	fine tunes the amount of whitespace to be added
" shiftwidth:	determines the amount of whitespace to add in normal mode
" expandtab:	when on use space instead of tab
" textwidth:	text wrap width
" autoindent:	autoindent in new line
set tabstop	=4

set softtabstop	=4
set shiftwidth	=4
set textwidth	=79
set expandtab
set autoindent


" show the matching part of pairs [] {} and () "
set showmatch




" remove trailing whitespace from Python and Fortran files "
autocmd BufWritePre *.py :%s/\s\+$//e
autocmd BufWritePre *.f90 :%s/\s\+$//e
autocmd BufWritePre *.f95 :%s/\s\+$//e
autocmd BufWritePre *.for :%s/\s\+$//e

" enable color themes "
if !has('gui_running')
	set t_Co=256
endif

" Change cursor shape in different modes
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END
" Remove space between vertical and horizontal splits
set fillchars-=vert:\|

" Map <C-d> to move down half a page and center the cursor line
nnoremap <C-d> <C-d>zz
" Map <C-u> to move up half a page and center the cursor line
nnoremap <C-u> <C-u>zz

" Map <leader>s to search and replace the word under the cursor
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
" Map <leader>x to make the current file executable
nnoremap <leader>x :!chmod +x %<CR>
vnoremap <leader>y "+y



" Map <C-w>f to open the current file in a new tab
nnoremap <silent> <C-w>f :tab split<CR>
nnoremap  <leader>fr :bro ol <CR>
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y



" Define a function s:sink with the abort attribute

" enable true colors support "
set termguicolors
" Vim colorscheme "
colorscheme habamax
