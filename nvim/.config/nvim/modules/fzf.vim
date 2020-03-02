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


let g:fzf_layout = { 'window': 'call FloatingFZF(1, 0.4, 0.599999, 0)' }

let s:fzf_files_exclude = [
    \ '.mypy_cache', '.ipynb_checkpoints', '__pycache__',
    \ '.git', 'undodir', '.eggs', '*.pyc'
    \ ]

let $FZF_DEFAULT_COMMAND= 'fd '
    \ . '--type f --hidden --no-ignore-vcs '
    \ . join(map(s:fzf_files_exclude, '"--exclude " . v:val'), ' ')

" Ag with preview on '?'
command! -bang -nargs=* Rg
    \ call fzf#vim#rg(<q-args>,
    \                 <bang>0 ? fzf#vim#with_preview('up:30%')
    \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
    \                 <bang>0)

