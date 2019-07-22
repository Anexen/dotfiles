set nocompatible

call plug#begin('~/.vim/plugged')

" theme
Plug 'kaicataldo/material.vim'
"Plug 'vim-airline/vim-airline'

" search + navigation
Plug 'mileszs/ack.vim'
Plug '/usr/bin/fzf'
Plug 'junegunn/fzf.vim'

Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'

" langs
Plug 'sheerun/vim-polyglot'
Plug 'w0rp/ale'
" Plug 'lifepillar/vim-mucomplete'

" Autocomplete
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-jedi'

" git
Plug 'airblade/vim-gitgutter'
" Plug 'tpope/vim-fugitive'

" misc
Plug 'liuchengxu/vim-which-key'
Plug 'tpope/vim-commentary'

call plug#end()

" Abbreviations
abbr funciton function
abbr teh the
abbr tempalte template
abbr fitler filter
abbr cosnt const
abbr attribtue attribute
abbr attribuet attribute

" Theme
set termguicolors
colorscheme material
set background=dark
let g:material_theme_style = 'dark'
let g:material_terminal_italics = 1
" let g:airline_theme = 'material'

set history=1000
" Disable beep / flash
set vb t_vb=
" Disable beep on errors.
" set noerrorbells
" Flash the screen instead of beeping on errors
" set visualbell

" file type recognition
filetype on
filetype plugin on
" Enable indentation rules that are file-type specific.
filetype indent on

syntax enable

" Make it easier to work with buffers
" http://vim.wikia.com/wiki/Easier_buffer_switching
set hidden
" Display a confirmation dialog when closing an unsaved file
set confirm
"set autowriteall
set wildmenu wildmode=full

set encoding=utf-8

set nowrap
" show cursor position on bottom left
set ruler
" show line numbers
set number
" Show line number on the current line and relative numbers on all other lines.
set relativenumber
set hidden
set path+=**
set ttyfast " faster redrawing

" Turn tabs into spaces and set them to be 4 spaces long
" set tabstop=4
" set softtabstop=4
" set shiftwidth=4
" New lines inherit the indentation of previous lines.
set autoindent
" Convert tabs to spaces.
set expandtab
" When shifting lines, round the indentation to the nearest multiple of shiftwidth
set shiftround
" When shifting, indent using four spaces.
set shiftwidth=4
" Insert “tabstop” number of spaces when the “tab” key is pressed.
set smarttab
"show results of substition as they're happening
set inccommand=nosplit
" highlight the current line of the buffer
set cursorline
" always work with system clipboard
set clipboard=unnamedplus
" allow the mouse to be used to change cursor position
set mouse=a

" Searching
set ignorecase " case insensitive searching
set smartcase " case-sensitive if expresson contains a capital letter
" Ignore files matching these patterns when opening files based on a glob pattern.
set wildignore+=.pyc,.swp

autocmd BufEnter * call ncm2#enable_for_buffer()

set completeopt=longest,menu,noselect,noinsert
" limit completion popup size
set pumheight=20

" suppress the annoying 'match x of y', 'The only match' and 'Pattern not found' messages
set shortmess+=c
" ALE
set omnifunc=ale#completion#OmniFunc
let g:python3_host_prog = '/home/archer/.pyenv/versions/braavo/bin/python'
let g:ale_set_highlights = 0
let g:ale_completion_enabled = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_error = '◆'
let g:ale_sign_warning = '▲'
let g:ale_sign_info = '●'
let g:ale_linters = {'python': ['pyls', 'spell_check']}
let g:ale_fixers = {'python': ['black', 'isort']}
highlight ALEErrorSign ctermfg=red
highlight ALEWarningSign ctermfg=yellow
highlight ALEInfoSign ctermfg=blue

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

nmap <ScrollWheelUp> <c-y>
nmap <ScrollWheelDown> <c-e>

" which key config
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>

call which_key#register('<Space>', "g:which_key_map")

" By default timeoutlen is 1000 ms
set timeoutlen=300

" nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
" vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

" Define prefix dictionary
let g:which_key_map =  {}

" Second level dictionaries:
" 'name' is a special field. It will define the name of the group, e.g., leader-f is the "+file" group.
" Unnamed groups will show a default empty string.

" =======================================================
" Create menus based on existing mappings
" =======================================================
" You can pass a descriptive text to an existing mapping.

let g:which_key_map.f = { 'name' : '+file' }

nnoremap <silent> <leader>fs :update<CR>
let g:which_key_map.f.s = 'save-file'

nnoremap <silent> <leader>fd :e $MYVIMRC<CR>
let g:which_key_map.f.d = 'open-vimrc'

nnoremap <silent> <leader>oq  :copen<CR>
nnoremap <silent> <leader>ol  :lopen<CR>
let g:which_key_map.o = {
      \ 'name' : '+open',
      \ 'q' : 'open-quickfix'    ,
      \ 'l' : 'open-locationlist',
      \ }

" =======================================================
" Create menus not based on existing mappings:
" =======================================================
" Provide commands(ex-command, <Plug>/<C-W>/<C-d> mapping, etc.) and descriptions for existing mappings
let g:which_key_map.b = {
      \ 'name' : '+buffer' ,
      \ '1' : ['b1'        , 'buffer 1']        ,
      \ '2' : ['b2'        , 'buffer 2']        ,
      \ 'd' : ['bd'        , 'delete-buffer']   ,
      \ 'f' : ['bfirst'    , 'first-buffer']    ,
      \ 'h' : ['Startify'  , 'home-buffer']     ,
      \ 'l' : ['blast'     , 'last-buffer']     ,
      \ 'n' : ['bnext'     , 'next-buffer']     ,
      \ 'p' : ['bprevious' , 'previous-buffer'] ,
      \ '?' : ['Buffers'   , 'fzf-buffer']      ,
      \ }


" Reloads vimrc after saving but keep cursor position
if !exists('*ReloadVimrc')
  fun! ReloadVimrc()
      let save_cursor = getcurpos()
      source $MYVIMRC
      call setpos('.', save_cursor)
  endfun
endif

autocmd! BufWritePost $MYVIMRC call ReloadVimrc()

" remove trailing spaces on write
autocmd FileType js,vim,py autocmd BufWritePre <buffer> %s/\s\+$//e

