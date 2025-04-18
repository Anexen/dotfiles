return {

    { "neovim/nvim-lspconfig" },

    { -- displays latest package versions in Cargo.toml file as virtual text.
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {},
    },

    { -- displays latest package versions in package.json file as virtual text.
        "vuki656/package-info.nvim",
        event = { "BufRead package.json" },
        opts = {},
    },

    {
        "alfredodeza/pytest.vim",
        ft = "python",
    },

    {
        "andythigpen/nvim-coverage",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = { "Coverage", "CoverageLoadLcov" },
        opts = {
            auto_reload = true,
            lcov_file = "coverage.lcov",
        },
    },

    { -- run HTTP requests directly from `.hurl` files
        "jellydn/hurl.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        ft = "hurl",
        keys = {
            { "<LocalLeader>a", ":HurlRunnerAt", ft = "hurl" },
            { "<LocalLeader>A", ":HurlRunner", ft = "hurl" },
            { "<LocalLeader>l", ":HurlShowLastResponse", ft = "hurl" },
        },
        opts = {
            env_file = { "vars.env", ".env" },
        },
    },

    -- "vxpm/ferris.nvim"
    -- "b0o/SchemaStore.nvim"
}
