" =============================================
" Basic Settings
" =============================================
set noerrorbells
set vb t_vb=
set mouse=a
let mapleader = " "
set path=.,**
set background=dark
syntax on
set incsearch hlsearch ignorecase smartcase
set noswapfile
set signcolumn=yes
set wildignorecase
set listchars=space:*,trail:*,nbsp:*,extends:>,precedes:<,tab:\|>
set termguicolors
set grepformat=%f:%l:%c:%m
set autoread
set linebreak
set relativenumber
set shortmess=aoOtTI
set ttyfast
set viminfo='20,<1000,s1000
set hidden
set history=100

" Enable syntax if available
if has("syntax")
  syntax enable
endif

" =============================================
" VI Compatibility
" =============================================
" Ensure settings work in basic vi mode
if v:progname =~? 'vi' && !has("eval")
  finish
endif

" =============================================
" Search and Navigation
" =============================================
nnoremap n nzzzv
nnoremap N Nzzzv
noremap <expr> j (v:count > 5 ? "jzz" : "j")
nnoremap <expr> k (v:count > 5 ? "kzz" : "k")
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap <C-L> :nohl<CR><C-L>

" =============================================
" File Types and Autocmds
" =============================================
let python_highlight_all = 1

augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

augroup vimrc_active_options
  au!
  au WinEnter,BufEnter * setlocal rnu nonu
  au WinLeave,BufLeave * setlocal nornu nonu
augroup END

runtime! ftplugin/man.vim

augroup force_go_ft
  autocmd!
  autocmd FileType godoc set filetype=go
augroup END

" Remove trailing whitespace on save
autocmd BufWritePre *.yml,*.md,*.go,*.py,*.f90,*.f95,*.for :%s/\s\+$//e
match Visual '\s\+$'

" Set filetype for container files
autocmd BufNewFile,BufRead *.container set filetype=ini

" =============================================
" Grep Configuration
" =============================================
if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading\
                \ --glob=!node_modules/*\
                \ --glob=!.terraform/*\
                \ --glob=!__pycache__/*\
                \ --glob=!terraform.tfstate\
                \ --glob=!terraform.tfstate.backup
else
    set grepprg=grep\ -rI\ -n\ -i\ -E\
                \ --exclude-dir=.git\
                \ --exclude-dir=node_modules\
                \ --exclude-dir=.terraform\
                \ --exclude-dir=__pycache__\
                \ --exclude=terraform.tfstate\
                \ --exclude=terraform.tfstate.backup
endif

" =============================================
" Editor Configuration
" =============================================
if v:progname =~? 'vim' || v:progname =~? 'nvim'
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
  set spell
  set wildmode=longest:full,full
  
  " Persistent undo
  if has("persistent_undo")
    if v:progname =~ 'nvim'
      let target_path = expand('~/.vim/undodir_nvim/')
    else
      let target_path = expand('~/.vim/undodir/')
    endif

    if !isdirectory(target_path)
      call mkdir(target_path, "p", 0700)
    endif

    let &undodir = target_path
    set undofile
  endif
endif

" =============================================
" Netrw Configuration
" =============================================
let g:netrw_banner = 0  " Hide the top banner
let g:netrw_winsize = 25  " Set default width

" =============================================
" Key Mappings
" =============================================
" General navigation and editing
nnoremap <leader>e :find 
nnoremap <leader>w :b 
nnoremap <leader><Space> :Explore<CR>
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
nnoremap <leader>x :!chmod +x %<CR>
nnoremap <leader>fr :bro ol<CR>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nmap <C-p> mzyyP`z
nnoremap <leader>o :execute 'tcd ' . fnameescape(expand('%:h'))<CR>fu

" Quickfix navigation
nnoremap <Leader>co :copen<CR>
nnoremap <Leader>cm :make \| copen<CR>
nnoremap <Leader>cc :cclose<CR>
nnoremap <Leader>cp :cprev<CR>
nnoremap <Leader>cn :cnext<CR>
nnoremap <leader>fc :silent grep!  `git ls-files` \| copen \| redraw!  <Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><left>
nnoremap <leader>fg :Grep 
""#nnoremap <leader>fc :silent grep! "<C-r>=expand("<cword>")<CR>" `git ls-files` | copen | redraw!<CR>
nnoremap <leader>fc :silent grep! "<C-r>=expand("<cword>")<CR>" `git ls-files` \| copen \| redraw!<CR>

" Completion
set completeopt=menuone
inoremap <C-F> <C-X><C-F>
inoremap <C-O> <C-X><C-O>
inoremap <C-L> <C-X><C-L>
" =============================================
" Clipboard Support
" =============================================
if v:progname =~? 'vim' || v:progname =~? 'nvim'
  if has('clipboard')
    vnoremap <Space>y "+y
    vnoremap <Leader>d "+d
  else
    vnoremap <Space>y "xy:call system('xclip -selection clipboard', @x)<CR>
    vnoremap <Leader>d "xd:call system('xclip -selection clipboard', @x)<CR>
  endif
endif

" =============================================
" Plugin Management
" =============================================
if empty(glob('~/.vim/autoload/plug.vim'))
  finish
endif

call plug#begin('~/.vim/plugged')
  Plug 'fatih/vim-go'
  Plug 'morhetz/gruvbox'
  Plug 'mbbill/undotree'
  Plug 'preservim/vim-markdown'
  Plug 'hashivim/vim-terraform'
  Plug 'lepture/vim-jinja'
  Plug 'psf/black', { 'branch': 'stable' }
  Plug 'davidhalter/jedi-vim'
  if has('nvim')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
  endif
call plug#end()

" =============================================
" Plugin Configurations
" =============================================
" UndoTree
nnoremap <leader>u :UndotreeToggle<CR>

" Golang settings
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
let g:go_highlight_function_parameters = 0
let g:go_code_completion_enabled = 1
let g:go_auto_sameids = 0

" Python/Jedi settings
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = "0"
let g:jedi#smart_auto_mappings = 0
let g:jedi#documentation_command = "K"
let g:jedi#goto_definitions_command = "gd"

augroup vimrc-python
  autocmd!
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=79
      \ formatoptions+=croq softtabstop=4
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

" Terraform settings
let g:terraform_fmt_on_save = 1

" Black (Python formatter)
augroup black_on_save
  autocmd!
  autocmd BufWritePre *.py Black
augroup end

" Markdown settings
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_frontmatter = 1
autocmd FileType markdown setlocal conceallevel=2 spell

" =============================================
" Compilers and Make Settings
" =============================================
autocmd Filetype go set makeprg=go\ build
autocmd FileType yaml setlocal makeprg=ansible-lint\ -f\ pep8\ --nocolor\ --parseable\ 
autocmd FileType yaml setlocal errorformat=%f:%l:\ %m
autocmd FileType python setlocal makeprg=python\ %
autocmd FileType terraform setlocal makeprg=terraform\ validate\ %
autocmd FileType sh,bash compiler shellcheck

autocmd FileType go nnoremap <leader>p :normal! ifmt.Println("")<CR><ESC>
au FileType go nmap <leader>n iif err != nil {return err<CR><ESC>
au FileType python nmap <leader>p iprint(
" =============================================
" Color Scheme Settings
" =============================================
if !empty(glob('~/.vim/plugged/gruvbox'))
  let g:gruvbox_italic=1
  let g:gruvbox_contrast_dark = 'hard'
  let g:gruvbox_sign_column = 'bg0'
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
highlight SpellBad cterm=underline gui=underline ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE

hi Violet guifg=#af87ff ctermfg=141
hi! link mkdHeading Violet
hi! link mkdDelimiter Violet
hi! link htmlH1 Violet

" =============================================
" Folding Settings
" =============================================
set foldmethod=manual
set nofoldenable

" =============================================
" Format Options
" =============================================
set fo-=t fo+=c fo-=r fo-=o fo+=q fo-=w fo-=a fo-=n fo+=j fo-=2 fo-=v fo-=b fo+=l fo+=m fo+=M fo-=B fo+=1

" =============================================
" Auto Commands and Misc Functions
" =============================================
augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

filetype plugin on


" Paste mode configuration
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[201~ XTermPasteBegin()

" Auto-closing pairs
function! ClosePair(opening, closing)
  let col = col('.')
  execute "normal! i" . a:opening
  execute "normal! a" . a:closing
  call cursor(line('.'), col)
endfunction

inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap ' ''<Left>
inoremap " ""<Left>
inoremap ` ``<Left>

" Automatically check for file updates
if ! exists("g:CheckUpdateStarted")
  let g:CheckUpdateStarted=1
  call timer_start(1,'CheckUpdate')
endif

function! CheckUpdate(timer)
  silent! checktime
  call timer_start(1000,'CheckUpdate')
endfunction

" Grep function from Romainl
function! Grep(...)
  return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost cgetexpr cwindow
  autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

" TMUX integration
if exists('$TMUX')
  autocmd BufEnter * call system('tmux rename-window ' . expand('%:p:h:t') . '/' . expand('%:t'))
endif
