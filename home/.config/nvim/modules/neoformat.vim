
" Run all enabled formatters (by default Neoformat stops after the first formatter succeeds)
let g:neoformat_run_all_formatters = 1

let g:neoformat_enabled_python = ['isort', 'black']

let g:neoformat_hcl_hclfmt = {'exe': 'hclfmt'}
let g:neoformat_enabled_hcl = ['hclfmt']

autocmd! BufWritePre * call RemoveTrailingWhitespaces()

