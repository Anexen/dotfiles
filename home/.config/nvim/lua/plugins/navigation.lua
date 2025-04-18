return {
    { -- generate tags in background
        "ludovicchabant/vim-gutentags",
        init = function()
            vim.g.gutentags_generate_on_new = 0
            vim.g.gutentags_generate_on_missing = 0
            vim.g.gutentags_generate_on_write = 1

            -- extra project roots
            vim.g.gutentags_project_root = { "Cargo.toml", ".git" }
            vim.g.gutentags_add_default_project_roots = 1
        end,
    },

    {
        "stevearc/aerial.nvim",
        cmd = "AerialToggle",
        opts = { icons = require("core.lspkind") },
    },

    { -- changes working directory to the project root
        "ahmedkhalf/project.nvim",
        main = "project_nvim",
        opts = {
            manual_mode = true,
            detection_methods = { "pattern" },
            patterns = {
                ".python-version",
                "Cargo.toml",
                "=site-packages",
                ".git",
                "init.lua",
            },
        },
    },

    { "stevearc/oil.nvim", opts = {} },
}
