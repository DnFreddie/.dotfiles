set noerrorbells
set vb t_vb=
set mouse=a
set path+=**
set  grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
set grepformat=%f:%l:%c:%m
let mapleader = " "
syntax on
set incsearch
set ignorecase
set smartcase
set undofile
let &undodir = expand('$HOME/.vim/undodir_vim')
set noswapfile
set signcolumn=yes
set smartcase
set tabstop	=4
set softtabstop	=4
set shiftwidth	=4
set textwidth	=79
set expandtab
set autoindent
set showmatch
set updatetime=100
set number relativenumber
set background=dark
set numberwidth=4
set signcolumn=no
set wildignorecase
nnoremap <leader>e :find 
nnoremap <leader>fg :silent! grep!  <Bar> copen<Left><Left><Left><Left><Left><Left><Left><Left>

nnoremap <leader><Space> :Explore<CR>

augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END
" Remove space between vertical and horizontal splits

" Map <C-d> to move down half a page and center the cursor line
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Map <leader>s to search and replace the word under the cursor
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
nnoremap <leader>x :!chmod +x %<CR>
vnoremap <leader>y "+y

nnoremap <silent> <C-w>f :tab split<CR>
nnoremap  <leader>fr :bro ol <CR>
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y

" Move selected lines down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
"---------------Paste and preserve cursor---------------
nmap <C-p> mzyyP`z

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[201~ XTermPasteBegin()

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

"---------------Look---------------
autocmd BufWritePre *.py :%s/\s\+$//e
autocmd BufWritePre *.f90 :%s/\s\+$//e
autocmd BufWritePre *.f95 :%s/\s\+$//e
autocmd BufWritePre *.for :%s/\s\+$//e


" Change cursor shape in different modes
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
"---------------Colors---------------
hi VertSplit ctermfg=black ctermbg=black guifg=black guibg=black
hi StatusLine ctermbg=8 ctermfg=0 guibg=#808080 guifg=black
hi StatusLineNC ctermbg=8 ctermfg=7 guibg=#808080 guifg=darkgrey
highlight LineNr ctermbg=black ctermfg=8 guibg=#000000 guifg=#808080
highlight CursorLineNr ctermbg=black ctermfg=8 guibg=#000000 guifg=#808080
highlight SignColumn ctermbg=NONE guibg=NONE
" Ensure the colorscheme is applied after these changes
if exists("g:colors_name")
  execute "colorscheme " . g:colors_name
endif
"---------------Custom Functions---------------
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

function! LimitOldFiles(max_length)
  let oldfiles = v:oldfiles
  if len(oldfiles) > a:max_length
    let v:oldfiles = oldfiles[0:a:max_length - 1]
  endif
endfunction

autocmd VimEnter * call LimitOldFiles(7)

function! SetZellnerColorscheme()
  if !empty(globpath(&runtimepath, "colors/zellner.vim"))
    colorscheme zellner
  else
    " Fallback to a default or another colorscheme if 'zellner' isn't available
    colorscheme default
  endif
endfunction

" Call the function to set the colorscheme
call SetZellnerColorscheme()
" Additional Highlights for Catppuccin Mocha Aesthetic
hi Normal          ctermbg=0       ctermfg=7       guibg=#1e1e2e   guifg=#cdd6f4
hi Pmenu           ctermbg=8       ctermfg=7       guibg=#313244   guifg=#cdd6f4
hi PmenuSel        ctermbg=0       ctermfg=7       guibg=#45475a   guifg=#cdd6f4
hi Visual          ctermbg=8       ctermfg=7       guibg=#45475a   guifg=NONE
hi Comment         ctermbg=NONE    ctermfg=8       guibg=NONE      guifg=#6c7086
hi String          ctermbg=NONE    ctermfg=2       guibg=NONE      guifg=#a6e3a1
hi Function        ctermbg=NONE    ctermfg=4       guibg=NONE      guifg=#89b4fa
hi Identifier      ctermbg=NONE    ctermfg=3       guibg=NONE      guifg=#cba6f7
hi Keyword         ctermbg=NONE    ctermfg=5       guibg=NONE      guifg=#f5c2e7
hi Type            ctermbg=NONE    ctermfg=6       guibg=NONE      guifg=#fab387
hi Constant        ctermbg=NONE    ctermfg=1       guibg=NONE      guifg=#f38ba8
" Highlight the Quickfix Line to make it more visible
hi QuickFixLine    ctermbg=5       ctermfg=0       guibg=#cba6f7   guifg=#1e1e2e
" Highlight Error Messages
hi ErrorMsg        ctermbg=1       ctermfg=15      guibg=#f38ba8   guifg=#cdd6f4
" Improve the look of warning and informative messages
hi WarningMsg      ctermbg=3       ctermfg=0       guibg=#fab387   guifg=#1e1e2e
hi MoreMsg         ctermbg=2       ctermfg=0       guibg=#a6e3a1   guifg=#1e1e2e
" Darker Active Status Line
hi StatusLine      ctermbg=0       ctermfg=8       guibg=#181825   guifg=#bac2de
" Darker Inactive Status Line
hi StatusLineNC    ctermbg=0       ctermfg=8       guibg=#11111b   guifg=#6c7086
