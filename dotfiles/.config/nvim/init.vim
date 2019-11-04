" ----------------------------------------------------------------------------
" Quick jump to:
" 1. lightline_anchor
" 2. lsp_anchor
" 3. neomake_anchor
" 4. neoformat_anchor
" 5. leader_bindings_anchor
" 6. localleader_bindings_anchor

" ----------------------------------------------------------------------------
"   Plugins

call plug#begin('~/.vim/plugged')

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
Plug 'majutsushi/tagbar'

" Syntax highlighting
Plug 'sheerun/vim-polyglot'

" LSP client
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Completion
Plug 'ncm2/ncm2' | Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-vim' | Plug 'Shougo/neco-vim'

" Linters and Fixers
Plug 'neomake/neomake'
Plug 'sbdchd/neoformat'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Miscellaneous
Plug 'Shougo/echodoc.vim'               " displays function signatures from completions
Plug 'airblade/vim-rooter'              " changes working directory to the project root
Plug 'tpope/vim-commentary'             " comment helper
Plug 'tpope/vim-surround'               " quoting/parenthesizing made simple
Plug 'tpope/vim-repeat'                 " better '.' repeat
Plug 'Asheq/close-buffers.vim'          " quickly close (bdelete) several buffers at once
Plug 'stefandtw/quickfix-reflector.vim' " edit entries in QuickFix window
Plug 'chrisbra/Colorizer'               " color colornames and codes
Plug 'dhruvasagar/vim-table-mode'       " automatic table creator & formatter
" Plug 'kshenoy/vim-signature'            " show marks in sign column

call plug#end()

" ----------------------------------------------------------------------------
"   Options

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

" ----------------------------------------------------------------------------
"   Utils

function! IsOnBattery()
    return readfile('/sys/class/power_supply/BAT0/status') == ['Discharging']
endfunction

function! IsQuickfixOpen()
    return len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist'))
endfunction

" TODO: improve
function! ToggleWhitespace()
    setlocal listchars+=space:·
    setlocal list

    if !exists('b:ws')
        highlight Conceal ctermbg=NONE ctermfg=240 cterm=NONE guibg=NONE guifg=#585858 gui=NONE
        highlight link Whitespace Conceal
        let b:ws = 1
    endif

    syntax clear Whitespace
    syntax match Whitespace / / containedin=ALL conceal cchar=·
    setlocal conceallevel=2 concealcursor=c
endfunction

" ----------------------------------------------------------------------------
"   Theme

set termguicolors
set background=dark

let g:onedark_terminal_italics = 1
" make background darker
let g:onedark_color_overrides = {
    \ 'black': {'gui': '#252525', 'cterm': '230'},
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


function! LightlineNeomake()
    return '%{neomake#statusline#LoclistStatus()}'
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


augroup GutentagsStatusLineRefresher
    autocmd!
    autocmd User GutentagsUpdating call lightline#update()
    autocmd User GutentagsUpdated call lightline#update()
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
    \       ['fileformat', 'fileencoding', 'filetype'],
    \       ['neomake', 'gutentags'],
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
    \ },
    \ 'component_expand': {
    \   'neomake': 'LightlineNeomake',
    \ },
    \ 'component_type' : {
    \     'neomake': 'error',
    \ },
    \ }


" ----------------------------------------------------------------------------
"   FZF

" Ag with preview on '?'
command! -bang -nargs=* Ag
    \ call fzf#vim#ag(<q-args>,
    \                 <bang>0 ? fzf#vim#with_preview('up:60%')
    \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
    \                 <bang>0)

" ----------------------------------------------------------------------------
"   Tags

let g:tagbar_sort = 0


" ----------------------------------------------------------------------------
"   LSP                                                             lsp_anchor

let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ }

" Diagnostics are disabled in favor of Neomake
let g:LanguageClient_diagnosticsEnable = 0


" ----------------------------------------------------------------------------
"   Completion

" important: :help Ncm2PopupOpen for more information
set completeopt=menuone,noinsert,noselect
" limit completion popup size
set pumheight=20
" suppress the annoying 'match x of y', 'The only match' and 'Pattern not found' messages
set shortmess+=c

let g:ncm2#matcher = 'substrfuzzy'

augroup ncm2
    autocmd!
    autocmd BufEnter * call ncm2#enable_for_buffer()
augroup END

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new line.
" inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

inoremap <silent> <C-Space> <C-r>=ncm2#manual_trigger()<CR>

" ----------------------------------------------------------------------------
"   Neomake                                                     neomake_anchor

if IsOnBattery()
    call neomake#configure#automake('w', 1000)
else
    " when writing or reading a buffer, and on changes in normal mode with no delay.
    call neomake#configure#automake('nrw')
endif


let g:neomake_python_enabled_makers = ['flake8']


let g:neomake_error_sign = {
    \   'text': '●',
    \   'texthl': 'NeomakeErrorSign',
    \ }
let g:neomake_warning_sign = {
    \   'text': '●',
    \   'texthl': 'NeomakeWarningSign',
    \ }
let g:neomake_message_sign = {
    \   'text': '●',
    \   'texthl': 'NeomakeMessageSign',
    \ }
let g:neomake_info_sign = {
    \   'text': '●',
    \   'texthl': 'NeomakeInfoSign'
    \ }

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

augroup fmt
  autocmd!
  autocmd BufWritePre * call RemoveTrailingWhitespaces()
augroup END

" ----------------------------------------------------------------------------
"   Git

" disable automatic key mappings
let g:gitgutter_map_keys = 0
" gitgutter will preserve non-gitgutter signs
let g:gitgutter_sign_allow_clobber = 0

" ----------------------------------------------------------------------------
"   EchoDoc

let g:echodoc#enable_at_startup = 1
" use neovim's floating window feature
let g:echodoc#type = 'floating'
" To use a custom highlight for the float window,
" change Pmenu to your highlight group
highlight link EchoDocFloat Pmenu

" ----------------------------------------------------------------------------
"   Rooter

" change directory for the current window only
let g:rooter_use_lcd = 1
" In case of non-project files, change to file's directory
let g:rooter_change_directory_for_non_project_files = 'current'

" ----------------------------------------------------------------------------
"   Terminal Keybindings

" https://github.com/junegunn/fzf.vim/issues/544
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<C-\><C-n>"

" ----------------------------------------------------------------------------
"   Keybindings

" exit insert mode by pressing jk
inoremap jk <Esc>

" (de)indent using tab in normal and visual modes
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

nmap <ScrollWheelUp> <C-y>
nmap <ScrollWheelDown> <C-e>

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

" +buffers

function! MoveBuffer(window) abort
    let l:cur_buf = bufnr('%')
    exe a:window."wincmd w"
    exe "b".l:cur_buf
endfunction

nnoremap <Leader>bq :copen<CR>
nnoremap <Leader>bl :lopen<CR>
nnoremap <Leader>bb :Buffers<CR>
nnoremap <Leader>bm :messages<CR>
nnoremap <Leader>bd :bd<CR>
nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bp :bprevious<CR>
nnoremap <Leader>bt :TagbarToggle<CR>
nnoremap <Leader>b<S-n> :enew<CR>

nnoremap <Leader>b1 :call MoveBuffer(1)<CR>
nnoremap <Leader>b2 :call MoveBuffer(2)<CR>
nnoremap <Leader>b3 :call MoveBuffer(3)<CR>
nnoremap <Leader>b4 :call MoveBuffer(4)<CR>

" +comment
nmap <Leader>cl gcc
vmap <Leader>cl gc
nmap <Leader>cp gcap
vmap <Leader>cp <Esc>gcap

" +errors
nnoremap <Leader>er :Neomake<CR>
nnoremap <Leader>e<S-r> :Neomake<Space>
nnoremap <Leader>el :lopen<CR>
nnoremap <Leader>ep :lprev<CR>
nnoremap <Leader>en :lnext<CR>

" +git/version control
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gc :BCommits<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>gl :Glog<CR>
nnoremap <Leader>gs :Gstatus<CR>

" +insert
nnoremap <Leader>ik O<Esc>j
nnoremap <Leader>ij o<Esc>k

" +jump
nnoremap <Leader>jd :e%:p:h<CR>
nnoremap <Leader>jr :e.<CR>

" +files
nnoremap <Leader>fs :update<CR>
nnoremap <Leader>fr :History<CR>

" +files/edit
nnoremap <Leader>fev :e $MYVIMRC<CR>
nnoremap <Leader>fer :source $MYVIMRC<CR>

nnoremap <Leader>feb :e ~/.config/bash/main.bash<CR>

" +files/yank
" nnoremap <Leader>fyy :<CR>
" nnoremap <Leader>fyY :<CR>
" nnoremap <Leader>fyL :<CR>

" +major mode
nmap <Leader>m <LocalLeader>

" +project
nnoremap <Leader>pf :Files<CR>
nnoremap <Leader>ps :terminal<CR>

" +search
nnoremap <Leader>sc :noh<CR>
nmap <Leader>sa <Plug>AgRawSearch
vmap <Leader>sa <Plug>AgRawVisualSelection<CR>
nmap <Leader>sw <Plug>AgRawWordUnderCursor<CR>
nnoremap <Leader>st :Tags<CR>
nnoremap <Leader>sp :Ag<CR>

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
"   LocalLeader Keybindings                        localleader_bindings_anchor

augroup lsp
    autocmd!
    autocmd FileType python
        \  nnoremap <buffer> <LocalLeader>gd :call LanguageClient#textDocument_definition()<CR>
        \| nnoremap <buffer> <LocalLeader>gt :call LanguageClient#textDocument_typeDefinition()<CR>
        \| nnoremap <buffer> <LocalLeader>gi :call LanguageClient#textDocument_implementation()<CR>
        \| nnoremap <buffer> <LocalLeader>r :call LanguageClient#textDocument_references()<CR>
        \| nnoremap <buffer> <LocalLeader><S-r> :call LanguageClient#textDocument_rename()<CR>
        \| nnoremap <buffer> <LocalLeader>h :call LanguageClient#textDocument_hover()<CR>
        \| nnoremap <buffer> <LocalLeader>s :call LanguageClient#textDocument_signatureHelp()<CR>
augroup END


augroup python
    autocmd!
    autocmd FileType python
        \  nnoremap <buffer> <LocalLeader>= :Neoformat black<CR>
        \| nnoremap <buffer> <LocalLeader>i :Neoformat isort<CR>
        \| nnoremap <buffer> <LocalLeader>db Oimport ipdb; ipdb.settrace()<Esc>
augroup END

augroup bash
    autocmd!
    autocmd Filetype bash setlocal shiftwidth=2 softtabstop=2 expandtab
augroup END

" ----------------------------------------------------------------------------
"   Abbreviations

" open help in vertical split
cnoreabbrev H vert h


abbr funciton function
abbr teh the
abbr tempalte template
abbr fitler filter
abbr cosnt const
abbr attribtue attribute
abbr attribuet attribute

