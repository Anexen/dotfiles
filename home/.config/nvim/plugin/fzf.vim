let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.4, 'xoffset': 0, 'yoffset': 1 } }

" excluded files are in ~/.fdignore
let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --no-ignore-vcs'
let $FZF_PREVIEW_COMMAND = '(bat --color=always --style=plain --theme TwoDark {} || tree -C {}) 2> /dev/null'

" Ag with preview on '?'
" command! -bang -nargs=* Ag
"     \ call fzf#vim#ag(<q-args>,
"     \                 <bang>0 ? fzf#vim#with_preview('up:30%')
"     \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
"     \                 <bang>0)

