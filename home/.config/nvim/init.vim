" TODO: move to plugin/ directory
runtime! modules/**/*.vim

function! WebSearch(...)
    let q = substitute(join(a:000, ' '), ' ', '+', 'g')
    silent! execute "!brave 'https://duckduckgo.com/?q=" . q . "'"
endfunction

command! -nargs=+ WebSearch call WebSearch(<f-args>)

" load packer on demand
" command! PackerBootstrap lua require('plugins').packer_bootstrap()
command! PackerClean packadd packer.nvim | lua require('plugins').clean()
command! PackerCompile packadd packer.nvim | lua require('plugins').compile()
command! PackerInstall packadd packer.nvim | lua require('plugins').install()
command! PackerProfile packadd packer.nvim | lua require('plugins').profile_output()
command! PackerStatus packadd packer.nvim | lua require('plugins').status()
command! PackerSync packadd packer.nvim | lua require('plugins').sync()
command! PackerUpdate packadd packer.nvim | lua require('plugins').update()
command! -nargs=+ -complete=customlist,v:lua.require'packer'.loader_complete
    \ PackerLoad lua require('plugins').loader(<q-args>)


function! EnableSpelling()
    syntax spell toplevel
    setlocal spell spelllang=en_us spelloptions=camel spellcapcheck=""
endfunction

augroup common
    autocmd!

    " color scheme overrides
    autocmd ColorScheme * execute "runtime after/colors/".expand("<amatch>").".vim"

    " highlight on yank
    if exists('##TextYankPost')
        autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
    endif

    " automatic PackerCompile on save
    autocmd BufWritePost plugins.lua PackerCompile

    " disable cursor line for inactive buffers
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline

    " spelling
    autocmd FileType python,javascript,markdown,rust call EnableSpelling()
augroup END
