call plug#begin('~/.local/share/nvim/plugged')

" Theme
Plug 'laggardkernel/vim-one'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" Searching
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'jesseleite/vim-agriculture'

" Tags
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}

" Syntax highlighting
Plug 'sheerun/vim-polyglot'
" Plug 'nvim-treesitter/nvim-treesitter'
Plug 'hashivim/vim-terraform', {'for': 'terraform'}

" LSP client
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Plug 'tpope/vim-dadbod', {'for': 'sql'}
Plug '/home/archer/projects/vim-dadbod', {'for': 'sql'}
Plug 'kristijanhusak/vim-dadbod-completion', {'for': 'sql'}

" snippets
" Plug 'sirver/ultisnips'
" Plug 'honza/vim-snippets'

" Completion
Plug 'ncm2/ncm2' | Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-vim' | Plug 'Shougo/neco-vim'
Plug 'ncm2/ncm2-tagprefix'
Plug 'ncm2/ncm2-bufword'
" Plug 'ncm2/ncm2-ultisnips'
" Plug 'fgrsnau/ncm2-otherbuf'

" Linters and Fixers
Plug 'neomake/neomake'
Plug 'sbdchd/neoformat'

" Miscellaneous
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
Plug 'weilbith/vim-localrc'             " secure exrc for local configs
Plug 'hkupty/iron.nvim'                 " Interactive Repls Over Neovim

Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }
Plug 'wellle/context.vim', { 'on': 'ContextToggle' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

Plug 'glacambre/firenvim', { 'do': { -> firenvim#install(0) } }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

Plug 'ruslan-savina/spelling'
" Plug '/home/archer/projects/spelling'
" Plug 'neovim/nvim-lsp'

" to try:
" Plug 'wellle/targets.vim'
" Plug 'justinmk/vim-sneak'               " ? replaces s, but faster then f
" Plug 'scrooloose/nerdtree'              " ? better file/dir management (move, rename, delete)
" Plug 'ripxorip/aerojump.nvim'

call plug#end()
