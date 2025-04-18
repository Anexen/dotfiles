
vim.filetype.add({
    extension = {
        hurl = "hurl",
    },
    filename = {
        ["inventory"] = "dosini",
        ["poetry.lock"] = "toml",
        ["devbox.json"] = "jsonc",
    }
})
