vim.g.gutentags_generate_on_new = 0
vim.g.gutentags_generate_on_missing = 0
vim.g.gutentags_generate_on_write = 1

-- extra project roots
vim.g.gutentags_project_root = {"Cargo.toml"}
vim.g.gutentags_add_default_project_roots = 1

vim.g.gutentags_ctags_extra_args = {"--languages=python,rust"}
vim.g.gutentags_ctags_exclude = {
    ".git",
    ".mypy_cache",
    ".ipynb_checkpoints",
    "__pycache__",
    "*.min.js",
    "target"
}

vim.g.tagbar_sort = 0
vim.g.tagbar_foldlevel = 0
vim.g.tagbar_autofocus = 1
vim.g.tagbar_compact = 1
