
function! DBConnect(...)
    let alias = get(a:, 1, 'default')
    let conn = get(get(g:, "databases", {}), alias, v:null)
    if empty(conn)
        echo "Connection " . name . " is not defined."
        return
    endif
    let b:db = conn
    DB b:db
    call vim_dadbod_completion#fetch(bufnr())
endfunction


function! DBConnections(ArgLead, CmdLine, CursorPos)
    return filter(keys(get(g:, "databases", {})), 'v:val =~ a:ArgLead')
endfunction


function! DBSendLines(start, end)
    let l:lines = filter(getline(a:start, a:end), 'v:val != ""')
    execute "DB " . join(l:lines, ' ')
endfunction


function! DBSendParagraph()
    let l:start = line("'{")
    let l:end = line("'}")
    call DBSendLines(l:start, l:end)
endfunction


function! DBSendQuery()
    let l:start = search('--{{', 'bcn') + 1
    let l:end = search('--}}', 'cn') - 1
    call DBSendLines(l:start, l:end)
endfunction


" disable built-in sql completion
let g:omni_sql_no_default_maps = 1
let g:loaded_sql_completion = 0

autocmd! FileType sql call DBConnect()

command! -nargs=? -complete=customlist,DBConnections DBConnect call DBConnect(<f-args>)
command! DBSendQuery call DBSendQuery()

nnoremap <buffer> <LocalLeader>s :call DBSendQuery()<CR>
nnoremap <buffer> <LocalLeader>p :call DBSendParagraph()<CR>
