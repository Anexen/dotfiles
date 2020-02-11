let g:python_smart_local_import = 1


function! PathAsImport(path, kind)
    let path = substitute(a:path, '/', '.', 'g')
    let path = substitute(path, '.py$', '', '')

    if a:kind == 'n'
        return 'import '
    endif

    return 'from ' . path . ' import '
endfunction


function! s:do_global_import(import_path)
    execute 'normal ggO' . a:import_path
endfunction


function! s:do_local_import(import_path)
    if ! get(g:, 'python_smart_local_import')
        execute "normal O" . a:import_path
        return
    endif

    let prev_indent = indent('.')
    normal [m
    let next_indent = indent('.')

    if prev_indent == next_indent
        " we are at class level
        execute "normal \<C-o>O" . a:import_path
    else
        execute "normal o" . a:import_path
    endif
endfunction


function! AutoImport(name, local)
    " find exact tag
    let tags = taglist('^'.a:name.'$')
    " filter top-level tags
    let tags = filter(tags, "v:val['cmd'][2] != ' '")

    if len(tags) < 1
        echohl WarningMsg
        echo "[AutoImport] Not found!"
        echohl None
        return
    endif

    let kinds = map(copy(tags), {i, x -> x['kind']})
    let matched_files = map(tags, {i, x -> x['filename']})

    for tagfile in tagfiles()
        let base = fnamemodify(tagfile, ':p:h')
        let matched_files = map(
        \   matched_files,
        \   {i, x -> substitute(x, base . '/', '', '')}
        \ )
    endfor

    " prepare import strings
    let matched_files = map(
    \   matched_files,
    \   {i, x -> PathAsImport(x, kinds[i]) . a:name}
    \ )

    let matched_files = uniq(matched_files)

    if a:local
        let ImportFn = function('s:do_local_import')
    else
        let ImportFn = function('s:do_global_import')
    endif

    " for single tag import immediately
    if len(matched_files) == 1
        call ImportFn(matched_files[0])
    else
        call fzf#run(fzf#wrap({
        \   'source': matched_files,
        \   'sink': ImportFn,
        \ }))
    endif
endfunction


function! OptimizeImports()
    let fn = expand('%')
    execute '!isort -rc -sl ' . fn
    execute '!autoflake --remove-all-unused-imports --in-place ' . fn
    Neoformat isort
endfunction
