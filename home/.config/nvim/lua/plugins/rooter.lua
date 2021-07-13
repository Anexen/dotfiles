vim.g.rooter_manual_only = 1
-- change directory for the current window only
vim.g.rooter_cd_cmd = "lcd"
-- In case of non-project files, change to file's directory
-- vim.g.rooter_change_directory_for_non_project_files = 'current'
vim.g.rooter_patterns = {
    ".python-version",
    "Cargo.toml",
    "=site-packages/",
    ".git/",
    ".git",
    "init.vim"
}
