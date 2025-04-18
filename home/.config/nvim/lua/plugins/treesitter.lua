local treesitter_opts = {
    -- Modules and its options go here
    ensure_installed = "all",
    highlight = {
        enable = true,
        -- disable = is_minified_file,
    },
    incremental_selection = {
        enable = true,
    },
    autotag = { -- windwp/nvim-ts-autotag plugin
        enable = true,
        -- disable = is_minified_file,
    },
    indent = { -- disable builtin indent module is favour to yati
        enable = false,
    },
    yati = { -- yioneko/nvim-yati
        enable = true,
        -- disable = is_minified_file,
    },
    textobjects = {
        swap = {
            enable = true,
            swap_next = {
                ["g>"] = "@parameter.inner",
            },
            swap_previous = {
                ["g<"] = "@parameter.inner",
            },
        },
        select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            -- You can use the capture groups defined in textobjects.scm
            keymaps = {
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
    },
}

return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-treesitter/nvim-treesitter-context",
        -- "CKolkey/ts-node-action",
        "yioneko/nvim-yati", -- fix indents
        "JoosepAlviste/nvim-ts-context-commentstring", -- setting the commentstring option based on the cursor location in the file
        { "windwp/nvim-ts-autotag", ft = { "html", "xml" } }, -- autoclose and autorename html tag
    },
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup(treesitter_opts)

        require("treesitter-context").setup({
            enable = false,
        })

        require("ts_context_commentstring").setup({
            enable_autocmd = false,
            config = {
                yaml = "# %s",
            },
        })

        -- override the Neovim internal get_option function which is called whenever the commentstring is requested:

        local builtin_get_option = vim.filetype.get_option
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.filetype.get_option = function(filetype, option)
            if option == "commentstring" then
                return require("ts_context_commentstring.internal").calculate_commentstring()
            else
                return builtin_get_option(filetype, option)
            end
        end
    end,
}
