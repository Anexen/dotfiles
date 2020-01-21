" _anchor (SPC s w) - Quick jump

" ----------------------------------------------------------------------------
"   Plugins                                                     plugins_anchor

call plug#begin('~/.config/nvim/plugged')

" Theme
Plug 'joshdick/onedark.vim'

" Status line
Plug 'itchyny/lightline.vim'

" Searching
Plug '/usr/bin/fzf'
Plug 'junegunn/fzf.vim'
Plug 'jesseleite/vim-agriculture'

" Tags
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar', {
    \ 'on': 'TagbarToggle'
    \ }

" Syntax highlighting
Plug 'sheerun/vim-polyglot'

" LSP client
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Completion
Plug 'ncm2/ncm2' | Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-vim' | Plug 'Shougo/neco-vim'
Plug 'ncm2/ncm2-tagprefix'
Plug 'ncm2/ncm2-bufword'
Plug 'fgrsnau/ncm2-otherbuf'

" Linters and Fixers
Plug 'neomake/neomake'
Plug 'sbdchd/neoformat'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Miscellaneous
Plug 'airblade/vim-rooter'              " changes working directory to the project root
Plug 'tpope/vim-commentary'             " comment helper
Plug 'tpope/vim-surround'               " quoting/parenthesizing made simple
Plug 'tpope/vim-repeat'                 " better '.' repeat
Plug 'Asheq/close-buffers.vim'          " quickly close (bdelete) several buffers at once
Plug 'stefandtw/quickfix-reflector.vim' " edit entries in QuickFix window
Plug 'norcalli/nvim-colorizer.lua'      " color colornames and codes
Plug 'dhruvasagar/vim-table-mode'       " automatic table creator & formatter
Plug 'lambdalisue/suda.vim'             " because sudo trick does not work on neovim.
Plug 'kshenoy/vim-signature'            " show marks in sign column
Plug 'takac/vim-hardtime'               " Habit breaking, habit making
Plug 'jeetsukumaran/vim-pythonsense'    " text objects for python statements

Plug 'wellle/context.vim', {
    \ 'on': ['ContextActivate', 'ContextEnable', 'ContextToggle']
    \ }

Plug 'mbbill/undotree', {
    \ 'on': 'UndotreeToggle'
    \ }

Plug 'glacambre/firenvim', {
    \ 'do': { _ -> firenvim#install(0) }
    \ }


" Plug 'neovim/nvim-lsp'

" to try:
" Plug 'sakhnik/nvim-gdb'                 " gdb integration
" Plug 'justinmk/vim-sneak'               " ? replaces s, but faster then f
" Plug 'scrooloose/nerdtree'              " ? better file/dir management (move, rename, delete)
" Plug 'sirver/ultisnips'

call plug#end()

" ----------------------------------------------------------------------------
"   Options                                                     options_anchor

" Enable indentation rules that are file-type specific.
filetype indent plugin on
" Enable syntax highlighting
syntax enable
" Display a confirmation dialog when closing an unsaved file
set confirm
" do not automatically wrap
set nowrap
" show line numbers
set number
" Show line number on the current line and relative numbers on all other lines.
set relativenumber
" Any buffer can be hidden (keeping its changes) without first writing the buffer to a file
set hidden
" Turn tabs into spaces and
set softtabstop=4
" set them to be 4 spaces long
set tabstop=4
" New lines inherit the indentation of previous lines.
set autoindent
" Convert tabs to spaces.
set expandtab
" When shifting lines, round the indentation to the nearest multiple of shiftwidth
set shiftround
" When shifting, indent using four spaces.
set shiftwidth=4
" Insert “tabstop” number of spaces when the “tab” key is pressed.
set smarttab
"show results of substition as they're happening
set inccommand=nosplit
" highlight the current line of the buffer
set cursorline
" always work with system clipboard
set clipboard=unnamedplus
" allow the mouse to be used to change cursor position
set mouse=a
" New splits open to right and bottom
set splitright
set splitbelow
" case insensitive searching
set ignorecase
" case-sensitive if expresson contains a capital letter
set smartcase
" Ignore files matching these patterns when opening files based on a glob pattern.
set wildignore+=.pyc,.swp
" enable local .vimrc
set exrc
" security limitations for local .vimrc files not owned by me
set secure
" always show sign column
set signcolumn=yes

set listchars+=space:·

" Maintain undo history between sessions
set undofile
set undodir=~/.config/nvim/undodir

set colorcolumn=0

set updatetime=500

set nobackup

" tree view in netrw
" let g:netrw_liststyle = 3

" ----------------------------------------------------------------------------
"   Firenvim                                                   firenvim_anchor

autocmd BufEnter localhost*ipynb*.txt set filetype=python
autocmd BufEnter github.com_*.txt set filetype=markdown

let g:firenvim_config = {
\   'localSettings': {
\       '.*': {
\           'cmdline': 'neovim',
\           'priority': 0,
\           'selector': 'textarea',
\           'takeover': 'never',
\       },
\   }
\ }

nnoremap <Esc><Esc> :call firenvim#focus_page()<CR>

" ----------------------------------------------------------------------------
"   Utils                                                         utils_anchor

function! IsOnBattery()
    if filereadable('/sys/class/power_supply/BAT0/status')
        return readfile('/sys/class/power_supply/BAT0/status') == ['Discharging']
    endif

    return 0
endfunction


function! IsQuickfixOpen()
    return len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist'))
endfunction


function! GoogleSearch(...)
    let q = substitute(join(a:000, ' '), ' ', '+', 'g')
    silent! execute '!chromium https://google.com/search?q=' . q
endfunction

command! -nargs=+ Google call GoogleSearch(<f-args>)


function! DisableWhitespace()
    setlocal nolist
    syntax clear Whitespace
    let b:whitespace_enabled = 0
endfunction


function! EnableWhitespace()
    setlocal list

    highlight Conceal ctermbg=NONE ctermfg=240 cterm=NONE guibg=NONE guifg=#585858 gui=NONE
    highlight link Whitespace Conceal

    syntax clear Whitespace
    syntax match Whitespace / / containedin=ALL conceal cchar=·
    setlocal conceallevel=2 concealcursor=c

    let b:whitespace_enabled = 1
endfunction


function! ToggleWhitespace()
    if get(b:, 'whitespace_enabled')
        call DisableWhitespace()
    else
        call EnableWhitespace()
    endif
endfunction


" ----------------------------------------------------------------------------
"   Theme                                                         theme_anchor

set termguicolors
set background=dark

let g:onedark_terminal_italics = 1
" make background darker
let g:onedark_color_overrides = {
    \ 'black': {'gui': '#202020', 'cterm': '230'},
    \}

colorscheme onedark

" ----------------------------------------------------------------------------
"   Lighline                                                  lightline_anchor

function! LightlineReadonly()
    return &readonly ? '' : ''
endfunction


function! LightlineFugitive()
    if exists('*fugitive#head')
        let branch = fugitive#head()
        return branch !=# '' ? ' '.branch : ''
    endif
    return ''
endfunction


function! LightlineNeomakeErrors()
    return '%{neomake#statusline#LoclistStatus()}'
endfunction


function! LightlineNeomakeJobs() abort
    let jobs = neomake#GetJobs()

    if empty(jobs)
        return ''
    endif

    let names = map(jobs, 'v:val.name')
    return '[' . join(names, ', ') . ']'
endfunction


function! LightlineFileFormat()
    if &fileformat == 'unix'
        return ''
    endif

    return winwidth(0) > 70 ? &fileformat : ''
endfunction


function! LightlineFileEncoding()
    if &fileencoding == 'utf-8'
        return ''
    endif

    return winwidth(0) > 70 ? &fileencoding : ''
endfunction


function! LightlineHardTime()
    if get(b:, 'hardtime_on')
        return '[hard]'
    endif

    return ''
endfunction


augroup _lightline_refresher
    autocmd!
    autocmd User GutentagsUpdating nested call lightline#update()
    autocmd User GutentagsUpdated nested call lightline#update()
    autocmd User NeomakeJobStarted nested call lightline#update()
    autocmd User NeomakeFinished nested call lightline#update()
augroup END


" TODO: filename: unique_tail_improved
let g:lightline = {
    \ 'colorscheme': 'onedark',
    \ 'active': {
    \   'left': [
    \       ['winnr'],
    \       ['paste'],
    \       ['readonly', 'relativepath', 'modified'],
    \   ],
    \   'right': [
    \       ['lineinfo'],
    \       ['percent'],
    \       ['fileformat', 'fileencoding', 'filetype', 'hardtime'],
    \       ['neomake_errors', 'gutentags'],
    \       ['neomake_jobs'],
    \   ]
    \ },
    \ 'inactive': {
    \   'left': [
    \       ['winnr'],
    \       ['readonly', 'filename', 'modified']
    \   ]
    \ },
    \ 'component': {
    \   'tagbar': '%{tagbar#currenttag("%s", "")}',
    \   'gutentags': '%{gutentags#statusline("[", "]")}',
    \ },
    \ 'component_function': {
    \   'fugitive': 'LightlineFugitive',
    \   'readonly': 'LightlineReadonly',
    \   'fileformat': 'LightlineFileFormat',
    \   'fileencoding': 'LightlineFileEncoding',
    \   'hardtime': 'LightlineHardTime',
    \   'neomake_jobs': 'LightlineNeomakeJobs',
    \ },
    \ 'component_expand': {
    \   'neomake_errors': 'LightlineNeomakeErrors',
    \ },
    \ 'component_type' : {
    \   'neomake_errors': 'error',
    \ },
    \}


" ----------------------------------------------------------------------------
"   FZF                                                             fzf_anchor

let s:fzf_files_exclude = [
    \ '.mypy_cache', '.ipynb_checkpoints', '__pycache__',
    \ '.git', 'undodir', '.eggs', '*.pyc'
    \ ]

let $FZF_DEFAULT_COMMAND= 'fd '
    \ . '--type f --hidden --no-ignore-vcs '
    \ . join(map(s:fzf_files_exclude, '"--exclude " . v:val'), ' ')

" Ag with preview on '?'
command! -bang -nargs=* Ag
    \ call fzf#vim#ag(<q-args>,
    \                 <bang>0 ? fzf#vim#with_preview('up:30%')
    \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
    \                 <bang>0)

" ----------------------------------------------------------------------------
"   Tags                                                           tags_anchor

let g:gutentags_generate_on_new = 0
let g:gutentags_generate_on_missing = 0
let g:gutentags_generate_on_write = 1

let g:gutentags_ctags_exclude = [
    \  '.git', '.mypy_cache', '.ipynb_checkpoints', '__pycache__',
    \ ]

let g:tagbar_sort = 0
let g:tagbar_foldlevel = 0
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1

" ----------------------------------------------------------------------------
"   LSP                                                             lsp_anchor

let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ 'rust': ['rls'],
    \ 'javascript': ['tcp://127.0.0.1:5001'],
    \ }

" Diagnostics are disabled in favor of Neomake
let g:LanguageClient_diagnosticsEnable = 0


" ----------------------------------------------------------------------------
"   Completion                                               completion_anchor

" important: :help Ncm2PopupOpen for more information
set completeopt=menuone,noinsert,noselect
" limit completion popup size
set pumheight=20
" suppress the annoying 'match x of y', 'The only match' and 'Pattern not found' messages
set shortmess+=c

let g:ncm2#matcher = 'substrfuzzy'

augroup _ncm2
    autocmd!
    autocmd BufEnter * call ncm2#enable_for_buffer()
augroup END

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new line.
" inoremap <expr> <CR> (pumvisible() ? "\<C-y>\<CR>" : "\<CR>")

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

inoremap <silent> <C-Space> <C-r>=ncm2#manual_trigger()<CR>

" ----------------------------------------------------------------------------
"   Neomake                                                     neomake_anchor

if IsOnBattery()
    call neomake#configure#automake('w', 1000)
else
    call neomake#configure#automake('nrw', 1000)
endif

let g:neomake_python_enabled_makers = ['flake8']

let g:neomake_place_signs = 1
let g:neomake_highlight_lines = 0
let g:neomake_highlight_columns = 0

let g:neomake_error_sign = {'text': '●', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '●', 'texthl': 'NeomakeWarningSign'}
let g:neomake_info_sign = {'text': '●', 'texthl': 'NeomakeInfoSign'}
let g:neomake_message_sign = {'text': '●', 'texthl': 'NeomakeMessageSign'}

highlight link NeomakeVirtualtextError NeomakeErrorSign
highlight link NeomakeVirtualtextWarning NeomakeWarningSign
highlight link NeomakeVirtualtextInfo NeomakeInfoSign
highlight link NeomakeVirtualtextMessage NeomakeMessageSign

" ----------------------------------------------------------------------------
"   Neoformat                                                 neoformat_anchor

function! RemoveTrailingWhitespaces()
    let search = @/
    let view = winsaveview()
    silent! %s/\s\+$//e
    let @/=search
    call winrestview(view)
endfunction

" Run all enabled formatters (by default Neoformat stops after the first formatter succeeds)
let g:neoformat_run_all_formatters = 1

let g:neoformat_enabled_python = ['isort', 'black']

augroup _format
  autocmd!
  autocmd BufWritePre * call RemoveTrailingWhitespaces()
augroup END

" ----------------------------------------------------------------------------
"   Miscellaneous                                         miscellaneous_anchor

" Plugin: gitgutter

" disable automatic key mappings
let g:gitgutter_map_keys = 0
" gitgutter will preserve non-gitgutter signs
let g:gitgutter_sign_allow_clobber = 0

" Plugin: rooter

" change directory for the current window only
let g:rooter_use_lcd = 1
" In case of non-project files, change to file's directory
" let g:rooter_change_directory_for_non_project_files = 'current'

let g:rooter_patterns = [
    \ 'init.vim',
    \ 'main.bash',
    \ '.git',
    \ '.git/',
    \ '.python-version',
    \ 'Cargo.toml',
    \ ]

" Plugin: Table mode

let g:table_mode_disable_mappings = 1

" Plugin: signature

" disable signature mappings
let g:SignatureMap = {}

" ----------------------------------------------------------------------------
"   Keybindings                                             keybindings_anchor

" https://github.com/junegunn/fzf.vim/issues/544
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<C-\><C-n>"

" exit insert mode by pressing jk
inoremap jk <Esc>

nnoremap vil ^vg_

" (de)indent using tab in normal and visual modes
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

nmap <ScrollWheelUp> <C-y>
nmap <ScrollWheelDown> <C-e>

function! s:visualSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

xnoremap * :<C-u>call <SID>visualSearch('/')<CR>/<C-r>=@/<CR><CR>
xnoremap # :<C-u>call <SID>visualSearch('?')<CR>?<C-r>=@/<CR><CR>

" ----------------------------------------------------------------------------
"   Leader Keybindings                                  leader_bindings_anchor

let g:mapleader = "\<Space>"
let g:maplocalleader = ','

" last used buffer
nnoremap <Leader><Tab> :e#<CR>
nnoremap <Leader>qq :qa<CR>

nnoremap <Leader>1 :1wincmd w<CR>
nnoremap <Leader>2 :2wincmd w<CR>
nnoremap <Leader>3 :3wincmd w<CR>
nnoremap <Leader>4 :4wincmd w<CR>

nnoremap <expr> <Leader>? ":vert h ".expand('<cword>')."<CR>"

" +buffers

function! MoveBuffer(window) abort
    let current_buffer = bufnr('%')
    execute a:window.'wincmd w'
    execute 'b'.current_buffer
endfunction

nnoremap <silent> <Leader>bq :copen<CR>
nnoremap <silent> <Leader>bl :lopen<CR>
nnoremap <silent> <Leader>bb :Buffers<CR>
nnoremap <silent> <Leader>bm :messages<CR>
" nnoremap <silent> <Leader>bd :b#\|bd#<CR>
nnoremap <silent> <Leader>bd :bd<CR>
nnoremap <silent> <Leader>bn :bnext<CR>
nnoremap <silent> <Leader>bp :bprev<CR>
nnoremap <silent> <Leader>bt :TagbarToggle<CR>
nnoremap <silent> <Leader>b<S-n> :enew<CR>

nnoremap <silent> <Leader>b1 :call MoveBuffer(1)<CR>
nnoremap <silent> <Leader>b2 :call MoveBuffer(2)<CR>
nnoremap <silent> <Leader>b3 :call MoveBuffer(3)<CR>
nnoremap <silent> <Leader>b4 :call MoveBuffer(4)<CR>

" +comment
nmap <Leader>cl gcc
vmap <Leader>cl gc
nmap <Leader>cp gcap
vmap <Leader>cp <Esc>gcap

" +errors
nnoremap <Leader>ed :lclose<CR>
nnoremap <Leader>er :Neomake<Space>
nnoremap <Leader>e<S-r> :Neomake<CR>
nnoremap <Leader>el :lopen<CR>
nnoremap <Leader>en :lnext<CR>
nnoremap <Leader>ep :lprev<CR>
nnoremap <Leader>ec :ll<CR>
" copy (save) loclist to qflist
nnoremap <Leader>es :call setqflist(getloclist(winnr()))<CR>

" +git/version control
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gc :BCommits<CR>
nnoremap <Leader>gl :Glog<CR>
nnoremap <Leader>gs :Gstatus<CR>

" +insert
nnoremap <Leader>ik O<Esc>j
nnoremap <Leader>ij o<Esc>k

" +list (QuickFix/LocList)
nnoremap <Leader>lq :copen<CR>
nnoremap <Leader>ll :lopen<CR>
nnoremap <expr> <Leader>ln (IsQuickfixOpen() ? ':cnext' : ':lnext')."\<CR>"
nnoremap <expr> <Leader>lp (IsQuickfixOpen() ? ':cprev' : ':lprev')."\<CR>"
nnoremap <expr> <Leader>lc (IsQuickfixOpen() ? ':cc' : ':ll')."\<CR>"
nnoremap <expr> <Leader>ld (IsQuickfixOpen() ? ':cclose' : ':lclose')."\<CR>"

" +jump

function! s:fzf_neighbouring_files()
  call fzf#run({
        \ 'source': 'fd --type f --max-depth=1 --hidden .',
        \ 'dir': expand('%:p:h'),
        \ 'sink': 'edit',
        \ 'down': '40%',
        \ })
endfunction

nnoremap <Leader>jd :e%:p:h<CR>
nnoremap <Leader>jn :call <SID>fzf_neighbouring_files()<CR>
nnoremap <Leader>jr :e.<CR>
nnoremap <Leader>jb :b bash<CR>
" jump tag
nnoremap <Leader>jt  <C-]>

" +files
nnoremap <Leader>fs :update<CR>
nnoremap <Leader>fr :History<CR>

" +files/edit
nnoremap <Leader>fev :e $MYVIMRC<CR>
nnoremap <Leader>fer :source $MYVIMRC<CR>
nnoremap <Leader>feb :e ~/.config/bash/main.bash<CR>

" +files/yank
" file name under cursor
nnoremap <silent> <Leader>fyc :let @+=expand('<cfile>')<CR>
" file name
nnoremap <silent> <Leader>fyn :let @+=expand('%:t')<CR>
" relative file name
nnoremap <silent> <Leader>fyy :let @+=expand('%:f')<CR>
" absolute file name
nnoremap <silent> <Leader>fy<S-y> :let @+=expand('%:p')<CR>
" relative file name with line number
nnoremap <silent> <Leader>fyl :let @+=expand('%:f').':'.line('.')<CR>
" absolute file name with line number
nnoremap <silent> <Leader>fy<S-l> :let @+=expand('%:p').':'.line('.')<CR>

" +mode
nnoremap <Leader>mc :ColorizerToggle<CR>
nnoremap <Leader>mh :HardTimeToggle<CR>
nnoremap <Leader>mt :TableModeToggle<CR>
nnoremap <Leader>mu :UndotreeToggle<CR>
nnoremap <Leader>mw :call ToggleWhitespace()<CR>
nnoremap <expr> <Leader>mr ":setlocal colorcolumn=".(&colorcolumn == '0' ? get(b:, 'textwidth', 0) : '0')."<CR>"
nnoremap <expr> <Leader>mn ":setlocal ".(&relativenumber ? "no" : "")."relativenumber<CR>"

" +marks
nmap <Leader<S-m> :Marks<CR>

" +project

function! s:get_projects()
    return 'fd --type d --hidden ".git$" ~/projects | xargs dirname | sed "s#${HOME}#~#g"'
endfunction

function! s:handle_selected_project(directory)
    execute 'edit '.fnameescape(a:directory)
    FZF
    call feedkeys('i')
endfunction

function! SwitchToProject()
    call fzf#run(fzf#wrap({
        \ 'source': <SID>get_projects(),
        \ 'sink': function('<SID>handle_selected_project'),
        \ 'down': '40%',
        \ }))
endfunction

command! Projects call SwitchToProject()


nnoremap <Leader>pf :Files<CR>
nnoremap <Leader>po :e TODOs.org<CR>
nnoremap <Leader>pp :Projects<CR>
nnoremap <Leader>pr :Rooter<CR>
nnoremap <Leader>pt :terminal<CR>

" +search
nnoremap <Leader>sc :noh<CR>
nmap <Leader>sa <Plug>AgRawSearch''<Left>
vmap <Leader>sa <Plug>AgRawVisualSelection<CR>
nmap <Leader>sw <Plug>AgRawWordUnderCursor<CR>
nmap <Leader>sl :Ag<UP><CR>
nnoremap <Leader>st :Tags<CR>
nnoremap <Leader>sp :Ag<CR>

nnoremap <Leader>sg :call GoogleSearch(expand('<cword>'))<CR>
vnoremap <Leader>sg :call GoogleSearch(@*)<CR>

" +tabs
nnoremap <Leader>tn :tabnext<CR>
nnoremap <Leader>tp :tabprev<CR>
nnoremap <Leader>td :tabclose<CR>
nnoremap <Leader>t<S-n> :tabnew<CR>

" +windows
nnoremap <Leader>ww :Windows<CR>
nnoremap <Leader>wd <C-w>c

nnoremap <Leader>ws <C-w>s
nnoremap <Leader>wv <C-w>v

nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wj <C-w>j
nnoremap <Leader>wk <C-w>k
nnoremap <Leader>wl <C-w>l

" balance windows
nnoremap <Leader>w= <C-w>=
" resise window
nnoremap <Leader>w<S-h> <C-w>5<
nnoremap <Leader>w<S-j> :resize +5<CR>
nnoremap <Leader>w<S-l> <C-w>5<
nnoremap <Leader>w<S-k> :resize -5<CR>

" ----------------------------------------------------------------------------
"   Local Overrides                                     local_overrides_anchor

function! SetLSPShortcuts()
    nnoremap <buffer> <LocalLeader>gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <buffer> <LocalLeader>g<S-d> :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
    nnoremap <buffer> <LocalLeader>gt :call LanguageClient#textDocument_typeDefinition()<CR>
    nnoremap <buffer> <LocalLeader>gi :call LanguageClient#textDocument_implementation()<CR>
    nnoremap <buffer> <LocalLeader>gr :call LanguageClient#textDocument_references()<CR>
    nnoremap <buffer> <LocalLeader><S-r> :call LanguageClient#textDocument_rename()<CR>
    nnoremap <buffer> <LocalLeader>h :call LanguageClient#textDocument_hover()<CR>
    nnoremap <buffer> <LocalLeader>s :call LanguageClient#textDocument_signatureHelp()<CR>
endfunction()

augroup _lsp
    autocmd!
    autocmd FileType python,javascript,rust call SetLSPShortcuts()
augroup END


function! SetPythonOverrides()
    let b:textwidth = 79

    setlocal foldmethod=indent nofoldenable foldlevel=1

    nnoremap <buffer> <LocalLeader>= :Neoformat black<CR>
    nnoremap <buffer> <LocalLeader>i :Neoformat isort<CR>
    nnoremap <buffer> <silent> <expr> <LocalLeader>o ":silent !isort -rc -sl ".expand('%')." && autoflake --remove-all-unused-imports --in-place ".expand('%')." && isort ". expand('%')."<CR>"

    " debug
    nnoremap <buffer> <LocalLeader>db Oimport ipdb; ipdb.set_trace()<Esc>

    " lint
    nnoremap <buffer> <LocalLeader>lm :Neomake mypy<CR>
    nnoremap <buffer> <LocalLeader>lf :Neomake flake8<CR>
    nnoremap <buffer> <LocalLeader>lp :Neomake pylint<CR>

    " syntax match pythonFunction /\v[[:alpha:]_]+\ze(\s?\()/
    " syntax match pythonAssignment /\v[[:alpha:]_]+\ze\s?\=/
    " highlight link pythonAssignment Define
endfunction

augroup _python
    autocmd!
    autocmd FileType python call SetPythonOverrides()
augroup END


function! SetRustOverrides()
    nnoremap <buffer> <LocalLeader>= :Neoformat rustfmt<CR>

    " TODO: neomake makers
    nnoremap <buffer> <LocalLeader>cb :!cargo build<CR>
    nnoremap <buffer> <LocalLeader>c<S-b> :!cargo build --release<CR>
    nnoremap <buffer> <LocalLeader>cr :!cargo run --release<CR>
    nnoremap <buffer> <LocalLeader>c<S-r> :!cargo run --release<CR>
endfunction


augroup _rust
    autocmd!
    autocmd FileType rust call SetRustOverrides()
augroup END


augroup _bash
    autocmd!
    autocmd Filetype bash setlocal shiftwidth=2 softtabstop=2 expandtab
augroup END


augroup _make
    autocmd!
    " Set Make tabs to tabs and not spaces
    autocmd FileType make setlocal noexpandtab shiftwidth=4
augroup END

" ----------------------------------------------------------------------------
"   Abbreviations                                         abbreviations_anchor

" open help in vertical split
cnoreabbrev H vert h


abbr apreinta aprenita
abbr fitler filter
abbr calss class
abbr imoprt import
abbr improt import
