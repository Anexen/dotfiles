function! WebSearch(...)
    let q = substitute(join(a:000, ' '), ' ', '+', 'g')
    silent! execute "!xdg-open 'https://duckduckgo.com/?q=" . q . "'"
endfunction

command! -nargs=+ WebSearch call WebSearch(<f-args>)

lua <<EOF
function PackerBootstrap()
    local execute = vim.api.nvim_command
    local fn = vim.fn

    local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
        execute 'packadd packer.nvim'
    end
end
EOF

" load packer on demand
command! PackerBootstrap lua PackerBootstrap()
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


function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun


augroup common
    autocmd!

    " color scheme overrides
    " autocmd ColorScheme * execute "runtime after/colors/" . expand("<amatch>") . ".vim"

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

    autocmd VimEnter * call localrc#apply_local_configurations(getcwd())
augroup END

" colorscheme onedarkpro
