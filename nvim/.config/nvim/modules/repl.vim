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

