augroup Colors
    autocmd!
    autocmd ColorScheme * execute "runtime after/colors/".expand("<amatch>").".vim"
augroup END

autocmd BufWritePost plugins.lua PackerCompile

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

runtime! modules/**/*.vim
