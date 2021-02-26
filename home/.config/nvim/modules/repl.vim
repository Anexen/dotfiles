lua << EOF
local iron = require("iron")

iron.core.add_repl_definitions {
  python = {
    django = {
      command = {
        "python", "manage.py", "shell_plus",
        "--quiet-load", "--", "--no-autoindent"
      },
      format = iron.fts.python.ipython.format,
    }
  },
}

iron.core.set_config {
  preferred = {
    python = "ipython",
  },
  repl_open_cmd = "botright 12split",
}

EOF

command! -nargs=1 IronReplName lua require('iron').core.repl_by_name(<f-args>)

" :lua require('iron').core.repl_by_name('django')

" function! TREPLSendFile()
"     let l:lines = getline(0, "$")
"     let l:term_id = g:neoterm.instances[g:neoterm.last_active].termid
"     call jobsend(l:term_id, extend(filter(l:lines, 'v:val != ""'), ['', '']))
" endfunction

" function! TREPLSendCell()
"     let l:start = search('##{', 'bcn') + 1
"     let l:end = search('##}', 'cn') - 1
"     let l:lines = getline(l:start, l:end)
"     let l:term_id = g:neoterm.instances[g:neoterm.last_active].termid
"     call jobsend(l:term_id, extend(filter(l:lines, 'v:val != ""'), ['', '']))
" endfunction

" function! SetREPLShotcuts()
"     nnoremap <buffer> <Leader>tl :TREPLSendLine<CR>
"     nnoremap <buffer> <Leader>tv :TREPLSendSelection<CR>
"     nnoremap <buffer> <Leader>ts :call TREPLSendCell()<CR>
"     nnoremap <buffer> <Leader>tf :call TREPLSendFile()<CR>

"     nnoremap <buffer> <Leader>tb O##{<Esc>j
"     nnoremap <buffer> <Leader>te o##}<Esc>k
"     nnoremap <buffer> <Leader>tc O##{<Esc>jo##}<Esc>k

"    " Use gx{text-object} in normal mode
"     nmap gx <Plug>(neoterm-repl-send)

"     " Send selected contents in visual mode.
"     xmap gx <Plug>(neoterm-repl-send)
" endfunction

" augroup _repl
"     autocmd!
"     autocmd FileType python call SetREPLShotcuts()
" augroup end
