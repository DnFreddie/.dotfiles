set noerrorbells
set vb t_vb=
set mouse=a
let mapleader = " "
set path-=/usr/include
set background=dark
syntax on
" Search settings
set incsearch
set ignorecase
set smartcase
set noswapfile
set signcolumn=no
set wildignorecase
set listchars=space:*,trail:*,nbsp:*,extends:>,precedes:<,tab:\|>
set termguicolors
set grepformat=%f:%l:%c:%m

if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading
else
    set grepprg=grep\ -rI\ -n\ -i
endif

if v:progname =~? 'vim'
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=79
set expandtab
set autoindent
set showmatch
set updatetime=100
set numberwidth=4
set omnifunc=syntaxcomplete#Complete
set wildmenu
set wildmode=longest:full,full
autocmd BufWritePre *.yml,*.md,*.go,*.py,*.f90,*.f95,*.for :%s/\s\+$//e
match Visual '\s\+$'

set undodir=undodir
set undofile

if has('nvim')
    let undodir = expand('~/.config/nvim/undodir')
else
    let undodir = expand('~/.vim/undodir')
endif

if !isdirectory(undodir)
  call mkdir(undodir, 'p', 0700)
endif
"--------------- Key binds ---------------
nnoremap <leader>e :find
nnoremap <leader><Space> :Lexplore<CR>
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
nnoremap <leader>x :!chmod +x %<CR>
nnoremap <leader>fr :bro ol<CR>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nmap <C-p> mzyyP`z
nnoremap <leader>o :execute 'tcd ' . fnameescape(expand('%:h'))<CR>fu

"--------------- Plugins ---------------
if empty(glob('~/.vim/autoload/plug.vim'))
    finish
endif

call plug#begin('~/.vim/plugged')
    Plug 'fatih/vim-go'
    Plug 'morhetz/gruvbox'
    Plug 'mbbill/undotree'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'preservim/vim-markdown'
    if has('nvim')
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
        Plug 'neoclide/coc.nvim', {'branch': 'release'}
    endif
call plug#end()

"--------------- Golang settings ---------------
let g:go_fmt_fail_silently = 0
let g:go_fmt_command = 'goimports'
let g:go_fmt_autosave = 1
let g:go_gopls_enabled = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_diagnostic_errors = 1
let g:go_highlight_diagnostic_warnings = 1
let g:go_code_completion_enabled = 1
let g:go_auto_sameids = 0
set updatetime=100

" Common Go macros
au FileType go nmap <leader>m ilog.Print("made")<CR><ESC>
au FileType go nmap <leader>n iif err != nil {return err}<CR><ESC>

nnoremap <leader>u :UndotreeToggle<CR>

"--------------- Color scheme ---------------
if !empty(glob('~/.vim/plugged/gruvbox'))
    let g:gruvbox_contrast_dark = 'hard'
    colorscheme gruvbox
else
    colorscheme habamax
    highlight SpellBad cterm=underline gui=underline ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
    highlight StatusLine ctermfg=white ctermbg=black guifg=#FFFFFF guibg=#000000
    highlight StatusLineNC ctermfg=gray ctermbg=black guifg=#888888 guibg=#000000
    highlight LineNr ctermbg=black ctermfg=9 guibg=#000000 guifg=#808080
    highlight CursorLineNr ctermbg=black ctermfg=8 guibg=#000000 guifg=#808080
    highlight SignColumn ctermbg=NONE guibg=NONE
    highlight Normal ctermfg=white guifg=white
    highlight VertSplit ctermfg=darkgray ctermbg=NONE guifg=#444444 guibg=NONE
    highlight WinSeparator ctermfg=NONE ctermbg=NONE
endif

set cinoptions+=:0 laststatus=0
"--------------- Markdown settings ---------------
hi Violet guifg=#af87ff ctermfg=141
hi! link mkdHeading Violet
hi! link mkdDelimiter Violet
hi! link htmlH1 Violet
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_frontmatter = 1
set foldmethod=manual
set nofoldenable
set shortmess=aoOtTI
set viminfo='20,<1000,s1000
autocmd FileType markdown setlocal conceallevel=2 spell
"---------------Formatting---------------
set fo-=t fo+=c fo-=r fo-=o fo+=q fo-=w fo-=a fo-=n fo+=j fo-=2 fo-=v fo-=b fo+=l fo+=m fo+=M fo-=B fo+=1

augroup CloseLoclistWindowGroup
    autocmd!
    autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

filetype plugin on

  if has('clipboard')
        vnoremap <Space>y "+y
        vnoremap <Leader>d "+d
    else
        vnoremap <Space>y "xy:call system('xclip -selection clipboard', @x)<CR>
        vnoremap <Leader>d "xd:call system('xclip -selection clipboard', @x)<CR>
    endif
endif
