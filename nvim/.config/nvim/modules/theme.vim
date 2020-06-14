let g:one_allow_italics = 1
let g:one_dark_syntax_bg = '#222222'

set termguicolors
set background=dark

" delegate colorscheme configuration to your after/colors/<colorscheme>.vim files
autocmd! ColorScheme * execute 'runtime after/colors/'. expand('<amatch>') .'.vim'

colorscheme one
