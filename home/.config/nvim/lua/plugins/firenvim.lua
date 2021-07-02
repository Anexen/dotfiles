vim.g.firenvim_config = {
    localSettings = {
        [".*"] = {
            cmdline = "neovim",
            priority = 0,
            selector = "textarea",
            takeover = "never",
        },
    }
}
