
let g:gutentags_generate_on_new = 0
let g:gutentags_generate_on_missing = 0
let g:gutentags_generate_on_write = 1

let g:gutentags_project_root = ['Cargo.toml']
let g:gutentags_add_default_project_roots = 1

let g:gutentags_ctags_extra_args = ['--languages=python,javascript,rust,cpp,c']
let g:gutentags_ctags_exclude = [
\   '.git', '.mypy_cache', '.ipynb_checkpoints', '__pycache__', '*.min.js'
\ ]

let g:tagbar_sort = 0
let g:tagbar_foldlevel = 0
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1

