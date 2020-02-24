function! RemoveTrailingWhitespaces()
    let search = @/
    let view = winsaveview()
    silent! %s/\s\+$//e
    let @/=search
    call winrestview(view)
endfunction


function! MoveBuffer(window) abort
    let current_buffer = bufnr('%')
    execute a:window.'wincmd w'
    execute 'b'.current_buffer
endfunction


function! IsOnBattery()
    if filereadable('/sys/class/power_supply/BAT0/status')
        return readfile('/sys/class/power_supply/BAT0/status') == ['Discharging']
    endif

    return 0
endfunction


function! IsQuickfixOpen()
    return len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist'))
endfunction


function! Highlight(group, fg, bg, attr, ...)
    let l:attrsp = get(a:, 1, "")
    " fg, bg, attr, attrsp
    if !empty(a:fg)
        exec "hi " . a:group . " guifg=" .  a:fg
    endif
    if !empty(a:bg)
        exec "hi " . a:group . " guibg=" .  a:bg
    endif
    if a:attr != ""
        exec "hi " . a:group . " gui=" .   a:attr
    endif
    if !empty(l:attrsp)
        exec "hi " . a:group . " guisp=" . l:attrsp
    endif
endfunction


function! HumanSize(bytes) abort
    let l:bytes = a:bytes
    let l:sizes = ['B', 'Kb', 'Mb', 'Gb']
    let l:i = 0
    while l:bytes >= 1000
        let l:bytes = l:bytes / 1000.0
        let l:i += 1
    endwhile
    return printf('%.1f%s', l:bytes, l:sizes[l:i])
endfun


function! StatuslineReadonly()
    return &readonly ? '' : ''
endfunction


function! StatuslineFugitive()
    if exists('*fugitive#head')
        let branch = fugitive#head()
        return branch !=# '' ? ' '.branch : ''
    endif
    return ''
endfunction


function! StatuslineNeomakeErrors()
    return '%{neomake#statusline#LoclistStatus()}'
endfunction


function! StatuslineNeomakeJobs() abort
    let jobs = neomake#GetJobs()

    if empty(jobs)
        return ''
    endif

    let names = map(jobs, 'v:val.name')
    return '[' . join(names, ', ') . ']'
endfunction


function! StatuslineFileFormat()
    if &fileformat == 'unix'
        return ''
    endif

    return winwidth(0) > 70 ? &fileformat : ''
endfunction


function! StatuslineHardTime()
    if get(b:, 'hardtime_on')
        return '[hard]'
    endif

    return ''
endfunction

