function! IsOnBattery()
    if filereadable('/sys/class/power_supply/BAT0/status')
        return readfile('/sys/class/power_supply/BAT0/status') == ['Discharging']
    endif

    return 0
endfunction


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


function! SetNeomakeLiveMode(mode)
    call neomake#configure#automake(a:mode ? 'rwn' : 'w', 1000)
    let g:neomake_live_mode = a:mode
endfunction

function! NeomakeLiveModeToggle()
    call SetNeomakeLiveMode(g:neomake_live_mode ? 0 : 1)
endfunction

" let g:neomake_terraform_tfsec_maker = {
"     \ 'exe': 'tfsec',
"     \ 'args': [],
"     \ 'errorformat': '%f:%l:%c: %m',
"     \}


command! Tfsec call s:tfsec()

" tfsec runs tfsec and prints adds the results to the quick fix buffer
function! s:tfsec() abort
    let lines = systemlist(['tfsec', expand('%:h'), '--format', 'csv', '--exclude-downloaded-modules'])
    call setqflist(map(lines[1:], function("s:tfsec_line_postprocess")))
endfunction

function! s:tfsec_line_postprocess(idx, line) abort
    let items = split(a:line, ',')
    return {
        \ "filename": expand("%:h") . '/' . items[0],
        \ "lnum": items[1],
        \ "col": items[2],
        \ "text": items[5] . ' [' . items[3] . '] ' . items[6],
        \ "type": "E",
        \}
endfunction

let g:neomake_python_ruff_maker = {
    \ 'exe': 'ruff',
    \ 'args': ['check', '--quiet', '--no-fix', '--output-format', 'text'],
    \ 'errorformat': '%f:%l:%c: %m',
    \ }

function! g:neomake_python_ruff_maker.InitForJob(jobinfo) abort
    if a:jobinfo.file_mode == 1
        return self
    endif

    let maker = deepcopy(self)
    let project_root = neomake#utils#get_project_root(a:jobinfo.bufnr)

    if empty(project_root)
        call add(maker.args, '.')
    else
        call add(maker.args, project_root)
    endif

    return maker
endfunction

let g:neomake_live_mode = 0
" call SetNeomakeLiveMode(g:neomake_live_mode)

let g:neomake_git_diff_config = {
\   'py': {'filetype': 'python', 'makers': ['ruff']},
\ }

let g:neomake_python_enabled_makers = ['ruff']
" let g:neomake_python_pylint_remove_invalid_entries = 1

let g:neomake_clippy_rustup_has_nightly = 1

let g:neomake_disable = 1

let g:neomake_place_signs = 1
let g:neomake_highlight_lines = 0
let g:neomake_highlight_columns = 1

let g:neomake_error_sign = {'text': '●', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '●', 'texthl': 'NeomakeWarningSign'}
let g:neomake_info_sign = {'text': '●', 'texthl': 'NeomakeInfoSign'}
let g:neomake_message_sign = {'text': '●', 'texthl': 'NeomakeMessageSign'}
