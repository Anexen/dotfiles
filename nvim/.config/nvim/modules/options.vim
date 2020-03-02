set nowrap

" Enable indentation rules that are file-type specific.
filetype indent plugin on
" Enable syntax highlighting
syntax enable
" Display a confirmation dialog when closing an unsaved file
set confirm
" do not automatically wrap
set nowrap
" show line numbers
set number
" Show line number on the current line and relative numbers on all other lines.
set relativenumber
" Any buffer can be hidden (keeping its changes) without first writing the buffer to a file
set hidden
" Turn tabs into spaces and
set softtabstop=4
" set them to be 4 spaces long
set tabstop=4
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
" New splits open to right and bottom
set splitright
set splitbelow
" case insensitive searching
set ignorecase
" case-sensitive if expresson contains a capital letter
set smartcase
" Ignore files matching these patterns when opening files based on a glob pattern.
set wildignore+=.pyc,.swp
" enable local .vimrc
set exrc
" security limitations for local .vimrc files not owned by me
set secure
" always show sign column
set signcolumn=yes
" use dot to show a space.
set listchars+=space:·
" characters to fill the statusline separators.
set fillchars=stl:-,stlnc:-
" Maintain undo history between sessions
set undofile
set nobackup

set colorcolumn=0

set updatetime=500

set foldmethod=marker

set nofoldenable

" disable built-in sql completion
let g:omni_sql_no_default_maps = 1
let g:loaded_sql_completion = 0

let g:python3_host_prog = expand('~/.pyenv/versions/dev/bin/python')

