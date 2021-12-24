local packer = nil

local function init()
    if packer == nil then
        packer = require('packer')
        packer.init({
            disable_commands = true,
            display = {
                open_fn = require('packer.util').float,
            }
        })
    end

    local use = packer.use
    packer.reset()

    -- Packer can manage itself
    use {"wbthomason/packer.nvim", opt = true}

    -- Theme
    -- use {
    --     'laggardkernel/vim-one',
    --     config = function()
    --         vim.g.one_allow_italics = 1
    --         vim.g.one_dark_syntax_bg = '#222222'
    --         vim.cmd("colorscheme one")
    --     end
    -- }

    use {
        'olimorris/onedarkpro.nvim',
        config = function()
            local onedarkpro = require("onedarkpro")
            onedarkpro.setup({
                hlgroups = {
                    TSVariable = { fg = "none" },
                    TSFuncMacro = { link = "Macro" },
                    CursorLineNr = {fg = "${blue}", style = "none" }
                },
                styles = {
                    comments = "italic",
                },
                options = {
                    italic = true, -- Use the themes opinionated italic styles?
                    underline = true, -- Use the themes opinionated underline styles?
                    undercurl = true, -- Use the themes opinionated undercurl styles?
                    transparency = true, -- Use a transparent background?
                    terminal_colors = true,
                    window_unfocussed_color = true,
                }
            })
            onedarkpro.load()
        end
    }

    -- Status Line and Bufferline
    -- use {
    --     "glepnir/galaxyline.nvim",
    --     config = function() require'plugins.galaxyline' end,
    -- }

    -- Syntax highlighting
    -- use "sheerun/vim-polyglot"

    use {
        "nvim-treesitter/nvim-treesitter",
        -- disable = true,
        run = ":TSUpdate",
        requires = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            {"windwp/nvim-ts-autotag", ft = {"html", "xml"}}, -- autoclose and autorename html tag
            {"romgrk/nvim-treesitter-context", cmd = "TSContextToggle"},
        },
        config = function() require"plugins.treesitter" end
    }

    use {
        "hashivim/vim-terraform",
        ft = "terraform",
        config = function()
            vim.g.terraform_fmt_on_save = 1
        end
    }

    -- Git
    use {
        "lewis6991/gitsigns.nvim",
        event = "BufRead",
        config = function() require("gitsigns").setup() end,
        requires = { "nvim-lua/plenary.nvim" },
    }
    use {"tpope/vim-fugitive", event = "BufRead"}
    use {"junegunn/gv.vim", cmd = "GV"}

    -- Search
    use {
        "junegunn/fzf.vim",
        requires = {"junegunn/fzf"},
        config=function()
            vim.g["fzf_layout"] = {
                window = { width = 1, height = 0.4, xoffset = 0, yoffset = 1, border = "sharp" }
            }
        end
    }
    use {
        "jesseleite/vim-agriculture",
        config=function()
            vim.g["agriculture#rg_options"] = "--smart-case"
        end
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
        config=function()
            require('telescope').setup{
                defaults = {
                    file_sorter =  require'telescope.sorters'.get_fzy_sorter,
                    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
                }
            }
        end
    }

    -- LSP
    use {
        "neovim/nvim-lspconfig",
        requires = {
            "williamboman/nvim-lsp-installer",
            "simrat39/rust-tools.nvim"
        },
        config = function() require"plugins.lsp" end,
    }

    use {
        "hrsh7th/nvim-compe",
        event = "InsertEnter",
        requires = {
            -- "ray-x/lsp_signature.nvim",
            {"tpope/vim-dadbod", ft = "sql"},
            {"kristijanhusak/vim-dadbod-completion", ft = "sql"},
        },
        config = function() require"plugins.completion" end
    }

    use {
        "hrsh7th/vim-vsnip",
        requires = {"hrsh7th/vim-vsnip-integ"}
    }

    -- Linters and Fixers
    use "neomake/neomake"
    use "sbdchd/neoformat"

    -- Miscellaneous
    use "stefandtw/quickfix-reflector.vim" -- edit entries in QuickFix window
    use "lambdalisue/suda.vim"             -- because sudo trick does not work on neovim.
    use "weilbith/vim-localrc"             -- secure exrc for local configs
    use "kshenoy/vim-signature"            -- show marks in sign column
    use "farfanoide/inflector.vim"         -- string inflection

    use {"takac/vim-hardtime", cmd = "HardTimeToggle"}
    use {"wellle/context.vim", cmd = "ContextToggle"}
    use {"tweekmonster/startuptime.vim", cmd = "StartupTime"}

--     use {  -- displays latest package versions in package.json file as virtual text.
--         "vuki656/package-info.nvim",
--         config = function () require("package-info").setup() end
--     }

    use { -- generate tags in background
        "ludovicchabant/vim-gutentags",
        config = function() require"plugins.tags" end,
    }
    use {"majutsushi/tagbar", cmd = "TagbarToggle"}

    use {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        config = function()
            vim.g.undotree_WindowLayout = 2
        end
    }

    -- use { -- changes working directory to the project root
    --     "airblade/vim-rooter",
    --     config = function() require"plugins.rooter" end,
    -- }

    use { -- changes working directory to the project root
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                manual_mode = true,
                detection_methods = { "pattern" },
                patterns = {
                    ".python-version",
                    "Cargo.toml",
                    "=site-packages",
                    ".git",
                    "init.vim",
                }
            }
        end
    }

    use {
        "glacambre/firenvim",
        run = function() vim.fn["firenvim#install"](0) end,
        config = function() require"plugins.firenvim" end,
    }

    use {  -- Google Translate
        "skanehira/translate.vim",
        cmd = "Translate",
        config = function()
            vim.g.translate_source = "en"
            vim.g.translate_target = "ru"
        end
    }

    use {
        "terrortylor/nvim-comment",
        config = function()
            require("nvim_comment").setup({
                marker_padding = true,
                comment_empty = false,
                line_mapping = "<leader>cl",
                operator_mapping = "<leader>c"
            })
        end
    }

    use {  -- colorizer
        "rrethy/vim-hexokinase",
        run = "make hexokinase",
        cmd = "HexokinaseToggle",
        config = function() require"plugins.hexokinase" end
    }

    use { -- Markdown preview
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        cmd = "MarkdownPreview",
        run = function() vim.fn["mkdp#util#install"]() end,
    }

    use { -- Interactive Repls Over Neovim
        "hkupty/iron.nvim",
        config = function() require"plugins.iron" end,
        opt = true,
    }
    -- use 'mfussenegger/nvim-dap'
    --Plug "Asheq/close-buffers.vim"          " quickly close (bdelete) several buffers at once
    --Plug "dhruvasagar/vim-table-mode"       " automatic table creator & formatter

    --" to try:
    --" Plug "wellle/targets.vim"
    --" Plug "justinmk/vim-sneak"               " ? replaces s, but faster then f
    --" Plug "ripxorip/aerojump.nvim"


end

local plugins = setmetatable({}, {
    __index = function(_, key)
        init()
        return packer[key]
    end
})

return plugins
