
" Basic Settings
" =============================================
set noerrorbells
set vb t_vb=
set mouse=a
let mapleader = " "
set path=.,**
set background=dark
syntax on
set incsearch  ignorecase smartcase "hlsearch
set noswapfile
set signcolumn=yes
set wildignorecase
set listchars=space:*,trail:*,nbsp:*,extends:>,precedes:<,tab:\|>
set termguicolors
set grepformat=%f:%l:%c:%m
set autoread
set linebreak
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

set hidden
" =============================================
" Search and Navigation
" =============================================
""nnoremap n nzzzv
""nnoremap N Nzzzv
""noremap <expr> j (v:count > 5 ? "jzz" : "j")
""nnoremap <expr> k (v:count > 5 ? "kzz" : "k")
"nnoremap <C-d> <C-d>zz
"nnoremap <C-u> <C-u>zz
nnoremap <C-L> :nohl<CR><C-L>

" =============================================
" File Types and Autocmds
" =============================================
let python_highlight_all = 1

augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END


runtime! ftplugin/man.vim

augroup force_go_ft
  autocmd!
  autocmd FileType godoc set filetype=go
  autocmd FileType ad set filetype=adoc
augroup END

" Remove trailing whitespace on save
autocmd BufWritePre *.adoc,*.yml,*.md,*.go,*.py,*.f90,*.f95,*.for :%s/\s\+$//e
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
nnoremap <leader>e :find<Space>

nnoremap <leader>w :b<Space>

nnoremap <leader>W :ls<CR>:tab sb<Space>
nnoremap <leader><Space> :Explore<CR>
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
nnoremap <leader>x :!chmod +x %<CR>
nnoremap <leader>fr :bro ol<CR>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nmap <C-p> mzyyP`z
nnoremap <leader>o :execute 'tcd ' . fnameescape(expand('%:h'))<CR>fu
nnoremap <leader>ca :mksession! ~/.vim/sessions/
nnoremap <leader>cs :so ~/.vim/sessions/
nnoremap <leader>l :<C-u>marks ASDFETasd<CR>:normal! `
let @t = "ciW\"\<C-r>=printf('{{ %s }}', @\")\<CR>\"\<Esc>"


" Quickfix navigation
nnoremap <Leader>co :copen<CR>
nnoremap <Leader>cm :make \| copen<CR>
nnoremap <Leader>cc :cclose<CR>
nnoremap <Leader>cp :cprev<CR>
nnoremap <Leader>cn :cnext<CR>
nnoremap <leader>fg :Grep<space>
command! -nargs=1 GitGrep silent grep! <args> `git ls-files` | copen | redraw!
nnoremap <leader>fc :GitGrep<space>


" Completion
set completeopt=menuone
inoremap <C-F> <C-X><C-F>
inoremap <C-O> <C-X><C-O>
inoremap <C-L> <C-X><C-L>
inoremap <C-K> <C-X><C-K>
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
Plug 'terrastruct/d2-vim'
  Plug 'fatih/vim-go'
  Plug 'morhetz/gruvbox'
  Plug 'mbbill/undotree'
  Plug 'preservim/vim-markdown'
  Plug 'hashivim/vim-terraform'
  Plug 'lepture/vim-jinja'
  Plug 'pearofducks/ansible-vim'
  Plug 'psf/black', { 'branch': 'stable' }
  Plug 'davidhalter/jedi-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
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

augroup systemd_filetype
  autocmd!
  autocmd BufRead,BufNewFile *.service,*.socket,*.timer set filetype=systemd
augroup END

" Terraform settings
let g:terraform_fmt_on_save = 1

" Black (Python formatter)
augroup black_on_save
  autocmd!
  autocmd BufWritePre *.py Black
augroup END

" Markdown settings
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_frontmatter = 1
autocmd FileType markdown setlocal conceallevel=2 spell

highlight MarkdownTodo ctermfg=Red guifg=Red
augroup markdown_todo_highlight
  autocmd!
  autocmd FileType markdown syntax match MarkdownTodo /#TODO\!/
augroup END

" =============================================
" Compilers and Make Settings
" =============================================

autocmd FileType yaml.ansible setlocal makeprg=ansible-lint\ -f\ pep8\ --nocolor\ --parseable\ .

autocmd FileType yaml.ansible setlocal errorformat=%f:%l:\ %m

augroup ansible_yaml
  autocmd!
  autocmd BufRead,BufNewFile *.yml set filetype=yaml.ansible
  autocmd BufRead,BufNewFile *.yaml set filetype=yaml.ansible
augroup END


autocmd Filetype go set makeprg=go\ build
autocmd FileType python setlocal makeprg=python\ %
autocmd FileType terraform setlocal makeprg=terraform\ validate\ %
autocmd FileType sh,bash compiler shellcheck

autocmd FileType go nnoremap <leader>p :normal! ifmt.Println("")<CR><ESC>
au FileType go nmap <leader>n iif err != nil {return err}<CR><ESC>
au FileType python nmap <leader>p iprint()
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

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[201~ XTermPasteBegin()

inoremap ( ()<C-g>U<Left>
inoremap [ []<Left>
inoremap { {}<Left>

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

highlight MarkdownTodo ctermfg=Red guifg=Red cterm=bold gui=bold
highlight MarkdownTag ctermfg=Cyan guifg=Red cterm=bold gui=bold
augroup markdown_todo_highlight
  autocmd!
  autocmd FileType markdown syntax match MarkdownTodo /#TODO!/ containedin=ALL
  autocmd FileType markdown call matchadd('MarkdownTag', '#\([A-Za-z0-9_]\+\)\>')
augroup END


autocmd FileType asciidoc setlocal foldmethod=expr foldexpr=getline(v:lnum)=~'^\\[source'?'>1':getline(v:lnum)=~'^----'?(getline(v:lnum-1)=~'^\\[source'?'1':'<1'):'='

function! DocumentHeaders()
    let l:filename = expand("%")
    let l:lines = getbufline('%', 0, '$')
    let l:lines = map(l:lines, {index, value -> {"lnum": index + 1, "text": value, "filename": l:filename}})

    if &filetype ==# 'markdown'
        call filter(l:lines, {_, value -> value.text =~# '^#\+ .*$'})
    elseif &filetype ==# 'asciidoc' || &filetype ==# 'asciidoctor'
        call filter(l:lines, {_, value -> value.text =~# '^=\+ .*$'})
    else
        call filter(l:lines, {_, value -> value.text =~# '^\(#\|=\)\+ .*$'})
    endif

    call setqflist(l:lines)
    copen
endfunction

nnoremap <leader>h :call DocumentHeaders()<CR>

if exists('$TMUX')
  let g:original_tmux_window_name = system('tmux display-message -p "#W" | tr -d "\n"')

  augroup tmux_window_name
    autocmd!
    autocmd BufEnter * call system('tmux rename-window ' . shellescape(expand('%:p:h:t') . '/' . expand('%:t')))
    autocmd VimLeave * call system('tmux rename-window ' . shellescape(g:original_tmux_window_name))
  augroup END
endif

augroup session_and_marks
  autocmd!
  autocmd VimLeavePre * if v:this_session != '' | exec "mks! " . v:this_session | endif
augroup END

augroup asciidoc_conceal
  autocmd!
  autocmd FileType asciidoc,adoc syntax match asciidocLinkMacro /link:[^[]*\[[^\]]*\]/ contains=asciidocLinkHidden,asciidocLinkText
  autocmd FileType asciidoc,adoc syntax match asciidocLinkHidden /link:[^[]*\[/ contained conceal
  autocmd FileType asciidoc,adoc syntax match asciidocLinkHidden /\]/ contained conceal
  autocmd FileType asciidoc,adoc highlight asciidocLinkMacro ctermfg=109 guifg=#83a598
  autocmd FileType asciidoc,adoc setlocal conceallevel=2
augroup END

