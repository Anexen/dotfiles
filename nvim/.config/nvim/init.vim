" Plugins {{{

call plug#begin('$XDG_DATA_HOME/nvim/plugged')

" Theme
Plug 'laggardkernel/vim-one'

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
" Plug 'fgrsnau/ncm2-otherbuf'

" Linters and Fixers
Plug 'neomake/neomake'
Plug 'sbdchd/neoformat'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" Miscellaneous
Plug 'kassio/neoterm'
Plug 'airblade/vim-rooter'              " changes working directory to the project root
Plug 'tpope/vim-commentary'             " comment helper
Plug 'Asheq/close-buffers.vim'          " quickly close (bdelete) several buffers at once
Plug 'stefandtw/quickfix-reflector.vim' " edit entries in QuickFix window
Plug 'dhruvasagar/vim-table-mode'       " automatic table creator & formatter
Plug 'lambdalisue/suda.vim'             " because sudo trick does not work on neovim.
Plug 'kshenoy/vim-signature'            " show marks in sign column
Plug 'takac/vim-hardtime'               " Habit breaking, habit making
Plug 'jeetsukumaran/vim-pythonsense'    " text objects for python statements
Plug 'farfanoide/inflector.vim'         " string inflection

Plug 'ruslan-savina/spelling'

Plug 'rrethy/vim-hexokinase', {
    \ 'do': 'docker run -v $(pwd):/mnt -w /mnt golang:1.13 make hexokinase'
    \ }

Plug 'tweekmonster/startuptime.vim', {
\   'on': 'StartupTime'
\ }

Plug 'wellle/context.vim', {
\   'on': ['ContextActivate', 'ContextEnable', 'ContextToggle']
\ }

Plug 'mbbill/undotree', {
\   'on': 'UndotreeToggle'
\ }

Plug 'glacambre/firenvim', {
\   'do': { _ -> firenvim#install(0) }
\ }

" Plug 'neovim/nvim-lsp'

" to try:
" Plug 'sakhnik/nvim-gdb'                 " gdb integration
" Plug 'justinmk/vim-sneak'               " ? replaces s, but faster then f
" Plug 'scrooloose/nerdtree'              " ? better file/dir management (move, rename, delete)
" Plug 'sirver/ultisnips'

" my plugins
Plug '$XDG_CONFIG_HOME/nvim/plugins/vim-googler'

call plug#end()
" }}}

" {{{ Configs

function! SourceLocal(relativePath)
    let root = expand('$XDG_CONFIG_HOME/nvim')
    let fullPath = root . '/'. a:relativePath
    exec 'source ' . fullPath
endfunction

call SourceLocal('config/utils.vim')
call SourceLocal('config/python.vim')
call SourceLocal('config/statusline.vim')

" disable built-in sql completion
let g:omni_sql_no_default_maps = 1
let g:loaded_sql_completion = 0

let g:python3_host_prog = expand('~/.pyenv/versions/dev/bin/python')

" }}}

" {{{  Options
set nowrap

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
" use dot to show a space.
set listchars+=space:·
" characters to fill the statusline separators.
set fillchars=stl:-,stlnc:-
" Maintain undo history between sessions
set undofile
set nobackup

set colorcolumn=0

set updatetime=500

set foldmethod=marker

set nofoldenable

" }}}

" netrw {{{

" NERDtree like setup
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 30

function! ExplorerToggle(dir)
    if exists("t:expl_buf_num")
        let expl_win_num = bufwinnr(t:expl_buf_num)
        if expl_win_num != -1
            let cur_win_nr = winnr()
            exec expl_win_num . 'wincmd w'
            close
            " exec cur_win_nr . 'wincmd w'
            unlet t:expl_buf_num
        else
            unlet t:expl_buf_num
        endif
    else
        exec '1wincmd w'
        exec 'Vexplore ' . a:dir
        let t:expl_buf_num = bufnr("%")
    endif
endfunction
" }}}

" Neoterm {{{

let g:neoterm_auto_repl_cmd = 0
let g:neoterm_autoscroll = 1

function! StartDjangoShell()
    call neoterm#do({ 'cmd': 'python manage.py shell', 'mod': 'vertical' })
    call neoterm#repl#term(g:neoterm.last_active)
    call g:neoterm.repl.exec(["%autoindent"])
endfunctio

function! TREPLSendFile()
    let l:lines = getline(0, "$")
    let l:term_id = g:neoterm.instances[g:neoterm.last_active].termid
    call jobsend(l:term_id, extend(filter(l:lines, 'v:val != ""'), ['', '']))
endfunction

function! TREPLSendCell()
    let l:start = search('##{', 'bcn') + 1
    let l:end = search('##}', 'cn') - 1
    let l:lines = getline(l:start, l:end)
    let l:term_id = g:neoterm.instances[g:neoterm.last_active].termid
    call jobsend(l:term_id, extend(filter(l:lines, 'v:val != ""'), ['', '']))
endfunction

function! SetREPLShotcuts()
    nnoremap <buffer> <Leader>tt :call StartDjangoShell()<CR>
    nnoremap <buffer> <Leader>tl :TREPLSendLine<CR>
    nnoremap <buffer> <Leader>tv :TREPLSendSelection<CR>
    nnoremap <buffer> <Leader>ts :call TREPLSendCell()<CR>
    nnoremap <buffer> <Leader>tf :call TREPLSendFile()<CR>

    nnoremap <buffer> <Leader>tb O##{<Esc>j
    nnoremap <buffer> <Leader>te o##}<Esc>k
    nnoremap <buffer> <Leader>tc O##{<Esc>jo##}<Esc>k

   " Use gx{text-object} in normal mode
    nmap gx <Plug>(neoterm-repl-send)

    " Send selected contents in visual mode.
    xmap gx <Plug>(neoterm-repl-send)
endfunction

augroup _repl
    autocmd!
    autocmd FileType python call SetREPLShotcuts()
augroup end

" }}}

" Utils {{{

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


function! WhitespaceToggle()
    if get(b:, 'whitespace_enabled')
        call DisableWhitespace()
    else
        call EnableWhitespace()
    endif
endfunction


function! SpellingToggle()
    augroup _spelling_update_group
        autocmd!
        if !get(b:, 'spelling_enabled', 0)
            autocmd BufEnter,InsertLeave,TextChanged * :call spelling#Update()
            call spelling#Update()
            let b:spelling_enabled = 1
        else
            call spelling#Clear()
            let b:spelling_enabled = 0
        endif
    augroup END
endfunction

" }}}

" Theme {{{

let g:one_allow_italics = 1
let g:one_dark_syntax_bg = '#222222'

set termguicolors
set background=dark

function! MyHighlights() abort
    highlight link Quote String

    highlight link NeomakeVirtualtextError NeomakeErrorSign
    highlight link NeomakeVirtualtextWarning NeomakeWarningSign
    highlight link NeomakeVirtualtextInfo NeomakeInfoSign
    highlight link NeomakeVirtualtextMessage NeomakeMessageSign

    call one#highlight('NeomakeErrorSign', g:terminal_color_1, '', '')
    call one#highlight('NeomakeWarningSign', g:terminal_color_3, '', '')
    call one#highlight('NeomakeInfoSign', g:terminal_color_4, '', '')

    call one#highlight('NeomakeError', g:terminal_color_1, '', 'underline')
    call one#highlight('NeomakeWarning', g:terminal_color_3, '', 'underline')
    call one#highlight('NeomakeInfo', g:terminal_color_4, '', 'underline')

    call one#highlight('StatusLine', g:one_dark_syntax_bg, g:one_dark_syntax_bg, '')
    call one#highlight('StatusLineNC', g:one_dark_syntax_bg, g:one_dark_syntax_bg, '')

    call one#highlight('StatusLineActiveNormalMode', g:terminal_color_0, g:terminal_color_2, 'bold')
    call one#highlight('StatusLineActiveInsertMode', g:terminal_color_0, g:terminal_color_4, 'bold')
    call one#highlight('StatusLineActiveVisualMode', g:terminal_color_0, g:terminal_color_5, 'bold')
    call one#highlight('StatusLineActiveReplaceMode', g:terminal_color_1, g:terminal_color_1, 'bold')

    call one#highlight('StatusLineActiveNormalModeText', g:terminal_color_2, g:terminal_color_0, '')
    call one#highlight('StatusLineActiveInsertModeText', g:terminal_color_4, g:terminal_color_0, '')
    call one#highlight('StatusLineActiveVisualModeText', g:terminal_color_5, g:terminal_color_0, '')
    call one#highlight('StatusLineActiveReplaceModeText', g:terminal_color_1, g:terminal_color_0, '')

    call one#highlight('StatusLineText', g:terminal_color_7, g:terminal_color_0, '')
    call one#highlight('StatusLineTextItalic', g:terminal_color_7, g:terminal_color_0, 'italic')

    call one#highlight('StatusLineInactiveMode', g:terminal_color_0, g:terminal_color_3, 'bold')
    call one#highlight('StatusLineInactiveModeText', g:terminal_color_3, g:terminal_color_0, '')

    call one#highlight('StatusLineError', g:terminal_color_1, g:terminal_color_0, '')
    call one#highlight('StatusLineWarning', g:terminal_color_3, g:terminal_color_0, '')
    call one#highlight('StatusLineInfo', g:terminal_color_4, g:terminal_color_0, '')

    highlight link StatusLineJobsSection StatusLineText
    call one#highlight('StatusLineExtensionSection', g:terminal_color_5, g:terminal_color_0, 'bold')
endfunction

augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END

colorscheme one

augroup Statusline
  autocmd!
  autocmd WinEnter,BufEnter * setlocal statusline=%!ActiveStatusLine()
  autocmd WinLeave,BufLeave * setlocal statusline=%!InactiveStatusLine()
augroup END

" }}}

" FZF {{{

let g:fzf_layout = { 'window': 'call FloatingFZF(1, 0.4, 0.599999, 0)' }

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

" }}}

" Tags {{{

let g:gutentags_generate_on_new = 0
let g:gutentags_generate_on_missing = 0
let g:gutentags_generate_on_write = 1

let g:gutentags_project_root = ['Cargo.toml']
let g:gutentags_add_default_project_roots = 1

let g:gutentags_ctags_extra_args = ['--languages=python,javascript,rust']
let g:gutentags_ctags_exclude = [
\   '.git', '.mypy_cache', '.ipynb_checkpoints', '__pycache__', '*.min.js'
\ ]

let g:tagbar_sort = 0
let g:tagbar_foldlevel = 0
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1

" }}}

" LSP {{{

let g:LanguageClient_serverCommands = {
\   'python': ['pyls'],
\   'rust': ['rustup', 'run', 'nightly', 'rls'],
\   'javascript': ['tcp://127.0.0.1:5001'],
\ }

" Diagnostics are disabled in favor of Neomake
let g:LanguageClient_diagnosticsEnable = 0

" }}}

" Colorizer {{{
let g:Hexokinase_ftEnabled = []
let g:Hexokinase_highlighters = ['backgroundfull']
let g:Hexokinase_refreshEvents = ['TextChanged', 'InsertLeave']
let g:Hexokinase_optInPatterns = [
\     'full_hex', 'triple_hex', 'colour_names',
\     'rgb', 'rgba', 'hsl', 'hsla',
\ ]

" }}}

" Completion {{{

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

" }}}

" Neomake {{{

if IsOnBattery()
    call neomake#configure#automake('w', 1000)
else
    call neomake#configure#automake('nrw', 1000)
endif

let g:neomake_git_diff_config = {
\   'py': {'filetype': 'python', 'makers': ['flake8']},
\ }

function! NeomakeGitDiff()
    let ext_patterns = map(keys(g:neomake_git_diff_config), {index, val -> '.'.val.'$'})
    let git_files = systemlist("git diff --name-only --cached --diff-filter=AM | grep '".join(ext_patterns, "|")."'")
    let l:maker_name_to_maker = {}
    for changed_file in git_files
        let ext = fnamemodify(changed_file, ':e')
        let ext_config = g:neomake_git_diff_config[ext]
        let changed_file_filetype = ext_config['filetype']
        let needed_makers = ext_config['makers']
        for maker_name in needed_makers
            if !has_key(maker_name_to_maker, maker_name)
                let l:maker_name_to_maker[maker_name] = deepcopy(neomake#GetMaker(maker_name, changed_file_filetype))
                let l:maker_name_to_maker[maker_name].append_file = 0
            endif
            let maker = l:maker_name_to_maker[maker_name]
            call add(maker.args, changed_file)
        endfor
    endfor
    call neomake#Make({'enabled_makers': values(l:maker_name_to_maker)})
endfunction

let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_clippy_rustup_has_nightly = 1

let g:neomake_place_signs = 1
let g:neomake_highlight_lines = 0
let g:neomake_highlight_columns = 1

let g:neomake_error_sign = {'text': '●', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '●', 'texthl': 'NeomakeWarningSign'}
let g:neomake_info_sign = {'text': '●', 'texthl': 'NeomakeInfoSign'}
let g:neomake_message_sign = {'text': '●', 'texthl': 'NeomakeMessageSign'}

" }}}

" Neoformat {{{

" Run all enabled formatters (by default Neoformat stops after the first formatter succeeds)
let g:neoformat_run_all_formatters = 1

let g:neoformat_enabled_python = ['isort', 'black']

autocmd! BufWritePre * call RemoveTrailingWhitespaces()

" }}}

" Miscellaneous {{{

" Plugin: firenvim

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

if get(g:, "started_by_firenvim")
    autocmd BufEnter localhost*ipynb*.txt set filetype=python
    autocmd BufEnter github.com_*.txt set filetype=markdown

    nnoremap <Esc><Esc> :call firenvim#focus_page()<CR>
endif

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
    \ '.git/',
    \ '.git',
    \ '.python-version',
    \ 'Cargo.toml',
    \ ]

" Plugin: Table mode

let g:table_mode_disable_mappings = 1

" Plugin: signature

" disable signature mappings
let g:SignatureMap = {}

" }}}

" ----------------------------------------------------------------------------
"   Keybindings                                             keybindings_anchor

" https://github.com/junegunn/fzf.vim/issues/544
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<C-\><C-n>"

" exit insert mode by pressing jk
inoremap jk <Esc>

onoremap il :<c-u>normal! _vg_<cr>
vnoremap il :<c-u>normal! _vg_<cr>

" (de)indent using tab in normal and visual modes
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" |-------------+---+-------------------+-------+-------------------|
" | Camelize    | c | Some Text To Work | gI$c  | someTextToWork    |
" | Privatize   | p | some_var          | gI$p  | _some_var         |
" | Constantize | C | some text to work | gI$C  | SOME_TEXT_TO_WORK |
" | Titleize    | t | some text to work | gI$t  | Some Text To Work |
" | Normalize   | n | SOME_TEXT_TO_WORK | gI$n  | some text to work |
" | FreeBallIt  | f | some text to work | gI$f& | some&text&to&work |
" | Pascalize   | P | some.text.to.work | gIiWP | SomeTextToWork    |
" | Slashify    | / | SOME_TEXT_TO_WORK | gIiw/ | some/text/to/work |
" | Dasherize   | - | some_text_to_work | gIiw- | some-text-to-work |
" | Dotify      | . | someTextToWork    | gIiw. | some.text.to.work |
" | Underscore  | _ | some text to work | gI$_  | some_text_to_work |
" |-------------+---+-------------------+-------+-------------------|
"
nmap gI <Plug>(Inflect)
vmap gI <Plug>(Inflect)

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

nnoremap <expr> K ":vert h ".expand('<cword>')."<CR>"

" +buffers

nnoremap <silent> <Leader>bq :copen<CR>
nnoremap <silent> <Leader>bl :lopen<CR>
nnoremap <silent> <Leader>bb :Buffers<CR>
nnoremap <silent> <Leader>bm :messages<CR>
nnoremap <silent> <Leader>bd :bd<CR>
nnoremap <silent> <Leader>b<S-d> :b#\|bd#<CR>
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
nnoremap <Leader>eg :call NeomakeGitDiff()<CR>
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
nnoremap <Leader>jd :call ExplorerToggle('%:p:h')<CR>
nnoremap <Leader>jr :call ExplorerToggle('.')<CR>
nnoremap <Leader>jb :b bash<CR>
" jump tag
nnoremap <Leader>jt  <C-]>

" +files
nnoremap <Leader>fs :update<CR>
nnoremap <Leader>fr :History<CR>
nnoremap <Leader>ff :call ExplorerToggle('.')<CR>

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
nnoremap <Leader>mc :ContextToggle<CR>
nnoremap <Leader>m<S-c> :HexokinaseToggle<CR>
nnoremap <Leader>mh :HardTimeToggle<CR>
nnoremap <expr> <Leader>mn ":setlocal ".(&relativenumber ? "no" : "")."relativenumber<CR>"
nnoremap <expr> <Leader>mr ":setlocal colorcolumn=".(&colorcolumn == '0' ? get(b:, 'textwidth', 0) : '0')."<CR>"
nnoremap <Leader>ms :SpellingToggle<CR>
nnoremap <Leader>mt :TableModeToggle<CR>
nnoremap <Leader>mu :UndotreeToggle<CR>
nnoremap <Leader>mw :call WhitespaceToggle()<CR>

" +project

function! s:get_projects()
    return 'fd --type d --hidden ".git$" --max-depth=3 ~/projects | xargs dirname | sed "s#${HOME}#~#g"'
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
nmap <Leader>sa <Plug>RgRawSearch''<Left>
vmap <Leader>sa <Plug>RgRawVisualSelection<CR>
nnoremap <Leader>sb :BLines<CR>
nmap <Leader>sw <Plug>RgRawWordUnderCursor<CR>
nmap <Leader>sl :Rg<Up><CR>
nnoremap <Leader>st :Tags<CR>
nnoremap <Leader>sp :Rg<CR>

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

" balance windows
nnoremap <Leader>w= <C-w>=
" resise window
nnoremap <Leader>wh <C-w>5<
nnoremap <Leader>wj :resize +5<CR>
nnoremap <Leader>wl <C-w>5<
nnoremap <Leader>wk :resize -5<CR>

" ----------------------------------------------------------------------------
"   Local Overrides                                     local_overrides_anchor

function! SetLSPShortcuts()
    if !has_key(g:LanguageClient_serverCommands, &filetype)
        return
    endif

    nnoremap <buffer> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <buffer> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <buffer> g<S-d> :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>

    nnoremap <buffer> <LocalLeader>gt :call LanguageClient#textDocument_typeDefinition()<CR>
    nnoremap <buffer> <LocalLeader>gi :call LanguageClient#textDocument_implementation()<CR>
    nnoremap <buffer> <LocalLeader>gr :call LanguageClient#textDocument_references()<CR>
    nnoremap <buffer> <LocalLeader><S-r> :call LanguageClient#textDocument_rename()<CR>
    nnoremap <buffer> <LocalLeader>s :call LanguageClient#textDocument_signatureHelp()<CR>
endfunction

autocmd! FileType * call SetLSPShortcuts()


function! SetPythonOverrides()
    let b:textwidth = 79

    setlocal foldmethod=indent nofoldenable foldlevel=5

    " import yank path as import
    nnoremap <buffer> <silent> <LocalLeader>iy :let @+=PathAsImport(expand('%:f'), 'c')<CR>
    " import paste
    nnoremap <buffer> <silent> <LocalLeader>ip :call AutoImport(expand('<cword>'), 1)<CR>
    nnoremap <buffer> <silent> <LocalLeader>i<S-p> :call AutoImport(expand('<cword>'), 0)<CR>
    nnoremap <buffer> <silent> <LocalLeader>ii :Neoformat isort<CR>
    nnoremap <buffer> <silent> <LocalLeader>io :silent call OptimizeImports()<CR>

    nnoremap <buffer> <LocalLeader>= :Neoformat black<CR>

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

autocmd! FileType python call SetPythonOverrides()


function! SetRustOverrides()
    nnoremap <buffer> <LocalLeader>= :Neoformat rustfmt<CR>

    " TODO: neomake makers
    nnoremap <buffer> <LocalLeader>cb :!cargo build<CR>
    nnoremap <buffer> <LocalLeader>c<S-b> :!cargo build --release<CR>
    nnoremap <buffer> <LocalLeader>cr :!cargo run --release<CR>
    nnoremap <buffer> <LocalLeader>c<S-r> :!cargo run --release<CR>
    nnoremap <buffer> <LocalLeader>ct :!cargo test<CR>
    nnoremap <buffer> <LocalLeader>c<S-t> :!cargo test<CR>
endfunction


autocmd! FileType rust call SetRustOverrides()

autocmd! Filetype bash setlocal shiftwidth=2 softtabstop=2 expandtab

" Set Make tabs to tabs and not spaces
autocmd! FileType make setlocal noexpandtab shiftwidth=4

" Abbreviations {{{

" open help in vertical split
cnoreabbrev H vert h

abbr apreinta aprenita
abbr aprentia aprenita

abbr fitler filter
abbr calss class
abbr imoprt import
abbr improt import

" }}}

" augroup Terminal
"   au!
"   au TermOpen * let g:last_terminal_job_id = b:terminal_job_id
" augroup END

" function! REPLSend(lines)
"   call jobsend(g:last_terminal_job_id, add(a:lines, ''))
" endfunction

" command! REPLSendLine call REPLSend([getline('.')])

" function! ShowMarks()
"   redir => cout
"   silent marks
"   redir END
"   let marks = split(cout, "\n")
" endfunction
