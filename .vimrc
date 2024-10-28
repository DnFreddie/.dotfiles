" Disable error bells
set noerrorbells
set vb t_vb=
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
set noswapfile
set signcolumn=yes
set smartcase

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


" Change cursor shape in different modes
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END
" Remove space between vertical and horizontal splits

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



"Plug"




set updatetime=100

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[201~ XTermPasteBegin()
set background=dark



function! ClosePair(opening, closing)
  let col = col('.')
  " Insert the opening character
  execute "normal! i" . a:opening
  " Insert the closing character and move the cursor back
  execute "normal! a" . a:closing
  call cursor(line('.'), col)
endfunction

inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap ' ''<Left>
inoremap " ""<Left>



" Move selected lines down
vnoremap J :m '>+1<CR>gv=gv

" Move selected lines up
vnoremap K :m '<-2<CR>gv=gv

nmap <C-p> mzyyP`z
hi VertSplit ctermfg=black ctermbg=black guifg=black guibg=black

" Set the statusline background to grey and text to black
hi StatusLine ctermbg=8 ctermfg=0 guibg=#808080 guifg=black
hi StatusLineNC ctermbg=8 ctermfg=7 guibg=#808080 guifg=darkgrey
set number relativenumber
set numberwidth=4
highlight LineNr ctermbg=black ctermfg=8 guibg=#000000 guifg=#808080
highlight CursorLineNr ctermbg=black ctermfg=8 guibg=#000000 guifg=#808080
set signcolumn=no
highlight SignColumn ctermbg=NONE guibg=NONE

" Ensure the colorscheme is applied after these changes
if exists("g:colors_name")
  execute "colorscheme " . g:colors_name
endif


function! RunOnVisual() range
    let saved_reg = getreg('a')
    normal! gv"ay

    let selected_text = getreg('a')

    call setreg('a', saved_reg)

    let command = input('Command to run: ', '', 'shellcmd')
    if empty(command)
        return
    endif
    let output = system(command, selected_text)

    let output = substitute(output, '\n$', '', '')

    execute 'normal! gv"_c' . escape(output, '\|')
endfunction

xnoremap f :<C-U>call RunOnVisual()<CR>

