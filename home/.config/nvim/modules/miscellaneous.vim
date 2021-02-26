" Plugin: undotree
let g:undotree_WindowLayout = 2

" Plugin: polyglot
let g:python_pep8_indent_searchpair_timeout = 20

" Plugin: Hexokinase
let g:Hexokinase_ftEnabled = []
let g:Hexokinase_highlighters = ['backgroundfull']
let g:Hexokinase_refreshEvents = ['TextChanged', 'InsertLeave']
let g:Hexokinase_optInPatterns = [
\     'full_hex', 'triple_hex', 'colour_names',
\     'rgb', 'rgba', 'hsl', 'hsla',
\ ]

" Plugin: spelling

" let g:spelling_enabled = 0
let g:spelling_ignore_buffer_types = ['qf', 'tagbar', 'vim-plug']
let g:spelling_update_events = ['TextChanged', 'InsertLeave', 'BufEnter', 'WinEnter']

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
let g:rooter_cd_cmd = "lcd"
" In case of non-project files, change to file's directory
" let g:rooter_change_directory_for_non_project_files = 'current'

let g:rooter_patterns = [
    \ 'init.vim',
    \ 'main.bash',
    \ '.python-version',
    \ 'Cargo.toml',
    \ '=site-packages/',
    \ '=lib/python*/',
    \ '.git/',
    \ '.git',
    \ ]

" Plugin: Table mode
let g:table_mode_disable_mappings = 1

" Plugin: quickfix-reflector
" let g:qf_write_changes = 0

" Plugin: vim-terraform
let g:terraform_fmt_on_save = 1

" Web search

function! WebSearch(...)
    let q = substitute(join(a:000, ' '), ' ', '+', 'g')
    silent! execute "!brave 'https://duckduckgo.com/?q=" . q . "'"
endfunction

command! -nargs=+ WebSearch call WebSearch(<f-args>)

" Highlight Yanked Text
" works in neovim 0.5
" for older versions use https://github.com/machakann/vim-highlightedyank.
if exists('##TextYankPost')
    augroup LuaHighlight
        autocmd!
        autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
    augroup END
endif
