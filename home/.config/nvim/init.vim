lua <<EOF
-- Leader/local leader - lazy.nvim needs these set first

vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[,]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
EOF

function! WebSearch(...)
    let q = substitute(join(a:000, ' '), ' ', '+', 'g')
    silent! execute "!xdg-open 'https://google.com/?q=" . q . "'"
endfunction

command! -nargs=+ WebSearch call WebSearch(<f-args>)


function! EnableSpelling()
    syntax spell toplevel
    setlocal spell spelllang=en_us spelloptions=camel spellcapcheck=""
endfunction


function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun


augroup common
    autocmd!

    " color scheme overrides
    autocmd ColorScheme * execute "runtime after/colors/" . expand("<amatch>") . ".vim"

    " highlight on yank
    if exists('##TextYankPost')
        autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
    endif

    " disable cursor line for inactive buffers
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline

    " spelling
    autocmd FileType python,javascript,markdown,rust call EnableSpelling()
augroup END

" colorscheme onedarkpro
