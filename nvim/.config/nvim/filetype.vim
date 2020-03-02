if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
    autocmd!
    autocmd BufNewFile,BufRead inventory setfiletype dosini
augroup END
