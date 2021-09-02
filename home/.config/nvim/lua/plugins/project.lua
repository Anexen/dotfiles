require("project_nvim").setup {
    manual_mode = true,
    detection_methods = {"pattern"},
    patterns = {
        ".python-version",
        "Cargo.toml",
        "=site-packages",
        -- ".git/",
        -- ".git",
        "init.vim",
    }
}
