" Web search

function! WebSearch(...)
    let q = substitute(join(a:000, ' '), ' ', '+', 'g')
    silent! execute "!brave 'https://duckduckgo.com/?q=" . q . "'"
endfunction

command! -nargs=+ WebSearch call WebSearch(<f-args>)

" Highlight Yanked Text
" works in neovim 0.5
" for older versions use https://github.com/machakann/vim-highlightedyank.
if exists('##TextYankPost')
    augroup LuaHighlight
        autocmd!
        autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
    augroup END
endif
