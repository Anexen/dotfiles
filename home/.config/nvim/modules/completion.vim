"
" important: :help Ncm2PopupOpen for more information
set completeopt=menuone,noinsert,noselect
" limit completion popup size
set pumheight=20
" suppress the annoying 'match x of y', 'The only match' and 'Pattern not found' messages
set shortmess+=c

let g:ncm2#matcher = 'substrfuzzy'

" let g:UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
" " c-j c-k for moving in snippet
" let g:UltiSnipsJumpForwardTrigger = "<C-j>"
" let g:UltiSnipsJumpBackwardTrigger = "<C-k>"

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new line.
" inoremap <expr> <CR> (pumvisible() ? "\<C-y>\<CR>" : "\<CR>")

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" inoremap <silent> <C-Space> <C-r>=ncm2#manual_trigger()<CR>

" imap <expr> <C-s> ncm2_ultisnips#expand_or("\<Plug>(ultisnips_expand)", 'm')
" vmap <C-s> <Plug>(ultisnips_expand)

" inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

let g:vim_dadbod_completion_mark = ''

call ncm2#register_source({
\   'name' : 'sql',
\   'priority': 9,
\   'subscope_enable': 1,
\   'scope': ['sql'],
\   'mark': 'sql',
\   'word_pattern': '[\w_]+',
\   'complete_pattern': '\."_',
\   'on_complete': [
\       'ncm2#on_complete#omni',
\       'vim_dadbod_completion#omni',
\   ],
\ })


augroup _ncm2
    autocmd!
    autocmd BufEnter * call ncm2#enable_for_buffer()
augroup END

