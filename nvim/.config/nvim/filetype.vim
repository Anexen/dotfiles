if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
    autocmd!
    autocmd BufNewFile,BufRead inventory setfiletype dosini

    autocmd BufNewFile,BufRead .gitignore setfiletype gitignore
    autocmd BufNewFile,BufRead */info/exclude setfiletype gitignore
    autocmd BufNewFile,BufRead ~/.config/git/ignore setfiletype gitignore
    autocmd BufNewFile,BufRead .fdignore setfiletype gitignore
    autocmd BufNewFile,BufRead .ignore setfiletype gitignore
    autocmd BufNewFile,BufRead .dockerignore setfiletype gitignore
augroup END
