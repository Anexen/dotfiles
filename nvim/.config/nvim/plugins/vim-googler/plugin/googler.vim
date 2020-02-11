function! GoogleSearch(...)
    let q = substitute(join(a:000, ' '), ' ', '+', 'g')
    silent! execute '!chromium https://google.com/search?q=' . q
endfunction

command! -nargs=+ Google call GoogleSearch(<f-args>)
