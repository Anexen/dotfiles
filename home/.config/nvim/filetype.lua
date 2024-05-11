
vim.filetype.add({
    extension = {
        vader = "vader",
        hurl = "hurl",
    },
    filename = {
        ["inventory"] = "dosini",
        ["poetry.lock"] = "toml",
    }
})

-- " *ignore files
-- autocmd BufNewFile,BufRead .gitignore setfiletype gitignore
-- autocmd BufNewFile,BufRead */info/exclude setfiletype gitignore
-- autocmd BufNewFile,BufRead ~/.config/git/ignore setfiletype gitignore
-- autocmd BufNewFile,BufRead .fdignore setfiletype gitignore
-- autocmd BufNewFile,BufRead .ignore setfiletype gitignore
-- autocmd BufNewFile,BufRead .dockerignore setfiletype gitignore
--
-- " vifm
-- autocmd BufRead,BufNewFile vifmrc :set filetype=vifm
-- autocmd BufRead,BufNewFile *vifm/colors/* :set filetype=vifm
-- autocmd BufRead,BufNewFile *.vifm :set filetype=vifm
