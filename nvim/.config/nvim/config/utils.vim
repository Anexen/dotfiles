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


function! FloatingFZF(width, height, top_margin, left_margin)
    function! s:create_float(hl, opts)
        let buf = nvim_create_buf(v:false, v:true)
        let opts = extend({'relative': 'editor', 'style': 'minimal'}, a:opts)
        let win = nvim_open_win(buf, v:true, opts)
        call setwinvar(win, '&winhighlight', 'NormalFloat:'.a:hl)
        call setwinvar(win, '&colorcolumn', '')
        return buf
    endfunction

    " Size and position
    let width = float2nr(&columns * a:width)
    let height = float2nr(&lines * a:height)
    let row = float2nr(&lines * a:top_margin)
    let col = float2nr(&lines * a:left_margin)

    " Border
    let top = '╭' . repeat('─', width - 2) . '╮'
    let mid = '│' . repeat(' ', width - 2) . '│'
    let bot = '╰' . repeat('─', width - 2) . '╯'
    let border = [top] + repeat([mid], height - 2) + [bot]

    " Draw frame
    let s:frame = s:create_float('Comment', {'row': row, 'col': col, 'width': width, 'height': height})
    call nvim_buf_set_lines(s:frame, 0, -1, v:true, border)

    " Draw viewport
    call s:create_float('Normal', {'row': row + 1, 'col': col + 2, 'width': width - 4, 'height': height - 2})
    autocmd BufWipeout <buffer> execute 'bwipeout' s:frame
endfunction
