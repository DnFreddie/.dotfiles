"#--------------- Common settings for both vi and vim---------------
set noerrorbells
set vb t_vb=
set mouse=a
let mapleader = " "
set path-=/usr/include
syntax on
set incsearch
set ignorecase
set smartcase
set noswapfile
set signcolumn=no
set wildignorecase
set listchars=space:·
set background=dark
set termguicolors 

set grepformat=%f:%l:%c:%m

if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading
else
    set grepprg=grep\ -rI\ -n\ -i
endif

if v:progname =~? 'vim'
"#---------------Vim-only options---------------
    set undofile
    let &undodir = expand('$HOME/.vim/undodir_vim')
    "set undolevels=10000
    "set undoreload=10000
    set signcolumn=no
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set textwidth=79
    set expandtab
    set autoindent
    set showmatch
    set updatetime=50
    set background=dark
    set numberwidth=4
    set termguicolors
    set omnifunc=syntaxcomplete#Complete
    autocmd BufWritePre *.py,*.f90,*.f95,*.for :%s/\s\+$//e
"#---------------Key binds---------------
    nnoremap <leader>e :find 
    nnoremap <leader><Space> :Explore<CR>
    nnoremap <C-d> <C-d>zz
    nnoremap <C-u> <C-u>zz
    nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
    nnoremap <leader>x :!chmod +x %<CR>
    nnoremap <leader>fr :bro ol<CR>
    vnoremap J :m '>+1<CR>gv=gv
    vnoremap K :m '<-2<CR>gv=gv
    nmap <C-p> mzyyP`z
		nnoremap <leader>o :execute 'tcd ' . fnameescape(expand('%:h'))<CR>fu
""#---------------User functions---------------
    function! XTermPasteBegin()
        set pastetoggle=<Esc>[201~
        set paste
        return ""
    endfunction
    inoremap <special> <expr> <Esc>[201~ XTermPasteBegin()
    inoremap ( ()<Left>
    inoremap [ []<Left>
    inoremap { {}<Left>
    inoremap ' ''<Left>
    inoremap " ""<Left>
    inoremap ` ``<Left>

    "let &t_SI = "\e[6 q"
    "let &t_EI = "\e[2 q"

vnoremap <Space>y "py:call system('xclip -selection clipboard', @p)<CR>


"#---------------Color scheme---------------
colorscheme  habamax
highlight SpellBad cterm=underline gui=underline ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
""hi StatusLine ctermbg=7 ctermfg=0 guibg=#C0C0C0 guifg=black
highlight StatusLine ctermfg=white ctermbg=black guifg=#FFFFFF guibg=#000000
""hi StatusLineNC ctermbg=8 ctermfg=7 guibg=#808080 guifg=#404040
highlight StatusLineNC ctermfg=gray ctermbg=black guifg=#888888 guibg=#000000

highlight LineNr ctermbg=black ctermfg=9 guibg=#000000 guifg=#808080
highlight CursorLineNr ctermbg=black ctermfg=8 guibg=#000000 guifg=#808080
highlight SignColumn ctermbg=NONE guibg=NONE
highlight Normal ctermfg=white guifg=white
highlight WinSeparator ctermfg=NONE ctermbg=NONE
highlight VertSplit ctermfg=darkgray ctermbg=NONE guifg=#444444 guibg=NONE

"#---------------Markdown---------------
hi Violet   guifg=#af87ff ctermfg=141
hi! link mkdHeading Violet
hi! link mkdDelimiter Violet
hi! link htmlH1 Violet
hi! link mkdHeading Violet
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_frontmatter = 1
autocmd FileType markdown setlocal conceallevel=2

"#---------------Plugins---------------
if empty(glob('~/.vim/autoload/plug.vim'))
  finish
endif

call plug#begin('~/.vim/plugged')

    Plug 'govim/govim'
    Plug 'mbbill/undotree'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'preservim/vim-markdown'

""#---------------Lsp setting---------------
nnoremap <leader>u :UndotreeToggle<CR>
if executable('pylsp')
    " pip install python-lsp-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
call plug#end()

endif

