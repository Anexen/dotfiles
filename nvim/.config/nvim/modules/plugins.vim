call plug#begin('~/.local/share/nvim/plugged')

" Theme
Plug 'laggardkernel/vim-one'

" Searching
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'jesseleite/vim-agriculture'

" Tags
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar', {
    \ 'on': 'TagbarToggle'
    \ }

" Syntax highlighting
Plug 'sheerun/vim-polyglot'

" LSP client
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Completion
Plug 'ncm2/ncm2' | Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-vim' | Plug 'Shougo/neco-vim'
Plug 'ncm2/ncm2-tagprefix'
Plug 'ncm2/ncm2-bufword'
" Plug 'fgrsnau/ncm2-otherbuf'

" Linters and Fixers
Plug 'neomake/neomake'
Plug 'sbdchd/neoformat'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" Miscellaneous
Plug 'kassio/neoterm'
Plug 'airblade/vim-rooter'              " changes working directory to the project root
Plug 'tpope/vim-commentary'             " comment helper
Plug 'Asheq/close-buffers.vim'          " quickly close (bdelete) several buffers at once
Plug 'stefandtw/quickfix-reflector.vim' " edit entries in QuickFix window
Plug 'dhruvasagar/vim-table-mode'       " automatic table creator & formatter
Plug 'lambdalisue/suda.vim'             " because sudo trick does not work on neovim.
Plug 'kshenoy/vim-signature'            " show marks in sign column
Plug 'takac/vim-hardtime'               " Habit breaking, habit making
Plug 'jeetsukumaran/vim-pythonsense'    " text objects for python statements
Plug 'farfanoide/inflector.vim'         " string inflection

Plug 'ruslan-savina/spelling'

Plug 'rrethy/vim-hexokinase', {
    \ 'do': 'docker run -v $(pwd):/mnt -w /mnt golang:1.13 make hexokinase'
    \ }

Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }

Plug 'wellle/context.vim', { 'on': 'ContextToggle' }

Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

Plug 'glacambre/firenvim', { 'do': { -> firenvim#install(0) } }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

" Plug 'neovim/nvim-lsp'

" to try:
" Plug 'sakhnik/nvim-gdb'                 " gdb integration
" Plug 'justinmk/vim-sneak'               " ? replaces s, but faster then f
" Plug 'scrooloose/nerdtree'              " ? better file/dir management (move, rename, delete)
" Plug 'sirver/ultisnips'
" Plug 'ripxorip/aerojump.nvim'
" Plug 'habamax/vim-sendtoterm'

call plug#end()
