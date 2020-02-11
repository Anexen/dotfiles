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


function! LightlineReadonly()
    return &readonly ? '' : ''
endfunction


function! LightlineFugitive()
    if exists('*fugitive#head')
        let branch = fugitive#head()
        return branch !=# '' ? ' '.branch : ''
    endif
    return ''
endfunction


function! LightlineNeomakeErrors()
    return '%{neomake#statusline#LoclistStatus()}'
endfunction


function! LightlineNeomakeJobs() abort
    let jobs = neomake#GetJobs()

    if empty(jobs)
        return ''
    endif

    let names = map(jobs, 'v:val.name')
    return '[' . join(names, ', ') . ']'
endfunction


function! LightlineFileFormat()
    if &fileformat == 'unix'
        return ''
    endif

    return winwidth(0) > 70 ? &fileformat : ''
endfunction


function! LightlineFileEncoding()
    if &fileencoding == 'utf-8'
        return ''
    endif

    return winwidth(0) > 70 ? &fileencoding : ''
endfunction


function! LightlineHardTime()
    if get(b:, 'hardtime_on')
        return '[hard]'
    endif

    return ''
endfunction

