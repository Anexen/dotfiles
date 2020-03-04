" Plugin: polyglot
let g:python_pep8_indent_searchpair_timeout = 10

" Plugin: Hexokinase
let g:Hexokinase_ftEnabled = []
let g:Hexokinase_highlighters = ['backgroundfull']
let g:Hexokinase_refreshEvents = ['TextChanged', 'InsertLeave']
let g:Hexokinase_optInPatterns = [
\     'full_hex', 'triple_hex', 'colour_names',
\     'rgb', 'rgba', 'hsl', 'hsla',
\ ]

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

let g:rooter_manual_only = 1
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

