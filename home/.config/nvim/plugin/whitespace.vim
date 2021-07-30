function! RemoveTrailingWhitespaces()
    let search = @/
    let view = winsaveview()
    silent! %s/\s\+$//e
    let @/=search
    call winrestview(view)
endfunction


function! DisableWhitespace()
    setlocal nolist
    syntax clear Whitespace
    let b:whitespace_enabled = 0
endfunction


function! EnableWhitespace()
    setlocal list

    highlight Conceal ctermbg=NONE ctermfg=240 cterm=NONE guibg=NONE guifg=#585858 gui=NONE
    highlight link Whitespace Conceal

    syntax clear Whitespace
    syntax match Whitespace / / containedin=ALL conceal cchar=·
    setlocal conceallevel=2 concealcursor=c

    let b:whitespace_enabled = 1
endfunction


function! WhitespaceToggle()
    if get(b:, 'whitespace_enabled')
        call DisableWhitespace()
    else
        call EnableWhitespace()
    endif
endfunction

autocmd! BufWritePre * call RemoveTrailingWhitespaces()
