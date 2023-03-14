"FZF Buffer Delete

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

func! s:find(pattern, path, ...)
    let cmd = 'rg %s -- %s%s'
    let args = join(['--column', '--line-number', '--no-heading', '--color=always', '--sort=path', '--trim'] + a:000)
    let pattern = empty(a:pattern) ? '''''' : shellescape(a:pattern)
    let path = empty(a:path) ? '' : ' ' . a:path
    call fzf#vim#grep(printf(cmd, args, pattern, path), 1, call('fzf#vim#with_preview', ['right', 'ctrl-/']), 0)
endfunc

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

command! -nargs=1 -complete=tag Find call s:find(<f-args>, "", '-F')
