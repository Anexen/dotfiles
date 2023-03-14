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


function! s:abc(input)
    let line = split(a:input, "\t")
    let @+=PathAsImport(line[1], line[-2]) . line[0]
endfunction

function! CopyTagImport()
    call fzf#vim#tags('', fzf#vim#with_preview({
    \   "placeholder": "--tag {2}:{-1}:{3..}",
    \   "sink": function('s:abc'),
    \ }))
endfunction

function! OptimizeImports()
    let fn = expand('%')
    execute '!isort -rc -sl ' . fn
    execute '!autoflake --remove-all-unused-imports --in-place ' . fn
    execute 'Neoformat isort'
endfunction


function! FindSitePackagesPaths()
    let code =<< trim END
    import site, os;
    site_packages = site.getsitepackages() + [os.path.dirname(os.__file__)]
    for path in site_packages:
        print(path)
    END

    return systemlist("python -", code)
endfunction


function! GenerateSitePackagesTags()
    let site_packages = FindSitePackagesPaths()

	let code =<< trim END
	import sys, os
	for path in sys.argv[1:]:
		os.chdir(path)
		os.system("ctags -R --languages=python --exclude=site-packages --exclude=test")
		os.system("sed -i '/\/\^ /d' tags")
	END

    call system('python - ' . join(site_packages, ' '), code)

    echo "Done"
endfunction

function! Noop(...)
    return v:null
endfunction

let b:textwidth = 79

setlocal foldmethod=indent nofoldenable foldlevel=5
" prevent installation vim.lsp.tagfunc
setlocal tagfunc=Noop
" setlocal tagfunc={->v:null}

" import yank path as import
nnoremap <buffer> <silent> <LocalLeader>iy :let @+=PathAsImport(expand('%:f'), 'c').expand('<cword>')<CR>
" import paste
nnoremap <buffer> <silent> <LocalLeader>ip :call AutoImport(expand('<cword>'), 1)<CR>
nnoremap <buffer> <silent> <LocalLeader>i<S-p> :call AutoImport(expand('<cword>'), 0)<CR>
nnoremap <buffer> <silent> <LocalLeader>ii :Neoformat isort<CR>
nnoremap <buffer> <silent> <LocalLeader>io :silent call OptimizeImports()<CR>

nnoremap <buffer> <LocalLeader>= :Neoformat black<CR>

" debug
nnoremap <buffer> <LocalLeader>db Obreakpoint()<Esc>

" lint
nnoremap <buffer> <LocalLeader>lm :Neomake mypy<CR>
nnoremap <buffer> <LocalLeader>lf :Neomake flake8<CR>
nnoremap <buffer> <LocalLeader>lp :Neomake pylint<CR>
