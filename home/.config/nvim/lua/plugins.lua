local packer = nil

local function packer_bootstrap()
    local execute = vim.api.nvim_command
    local fn = vim.fn

    local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
        execute 'packadd packer.nvim'
    end
end

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

    -- Theme & Syntax highlighting
    use "sheerun/vim-polyglot"

    use {
        "hashivim/vim-terraform",
        ft = "terraform",
        config = function()
            vim.g.terraform_fmt_on_save = 1
        end
    }

    use {
        "navarasu/onedark.nvim",
        config = function()
            vim.g.onedark_style = "warmer"
            vim.cmd("colorscheme onedark")
        end
    }

    use {
        "nvim-treesitter/nvim-treesitter",
        -- disable = true,
        run = ":TSUpdate",
        requires = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            {"romgrk/nvim-treesitter-context", cmd = "TSContextToggle"},
        },
        config = function()
            -- require"treesitter-context.config".setup{
            --     enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
            -- }
            require"nvim-treesitter.configs".setup {
                -- Modules and its options go here
                ensure_installed = {
                    "bash", "python", "rust", "dockerfile", "lua",
                    "javascript", "typescript", "tsx",
                    "html", "toml", "json",
                },
                highlight = { enable = true },
                incremental_selection = { enable = true },
                -- indent = { enable = true },
                textobjects = {
                    select = {
                        enable = true,
                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,
                        -- You can use the capture groups defined in textobjects.scm
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        }
                    },
                }
            }
        end
    }

    -- Git
    use {
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        event = "BufRead",
        config = function()
            require("gitsigns").setup()
        end
    }
    use {"tpope/vim-fugitive", event = "BufRead"}
    use {"junegunn/gv.vim", cmd = "GV"}

    -- Searching
    use {"junegunn/fzf.vim", requires = {"junegunn/fzf"}}
    use {
        "jesseleite/vim-agriculture",
        config=function()
            vim.g["agriculture#rg_options"] = "--smart-case"
        end
    }

    use "neovim/nvim-lspconfig"

    use {
        "hrsh7th/nvim-compe",
        requires = {
            {"tpope/vim-dadbod", ft="sql"},
            {"kristijanhusak/vim-dadbod-completion", ft="sql"},
        }
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

    use { -- generate tags in background
        "ludovicchabant/vim-gutentags",
        config = function()
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
        end
    }

    use {
        "majutsushi/tagbar",
        cmd = "TagbarToggle",
        config = function()
            vim.g.tagbar_sort = 0
            vim.g.tagbar_foldlevel = 0
            vim.g.tagbar_autofocus = 1
            vim.g.tagbar_compact = 1
        end
    }

    use {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        config = function()
            vim.g.undotree_WindowLayout = 2
        end
    }

    use { -- changes working directory to the project root
        "airblade/vim-rooter",
        config = function()
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
            }
        end
    }

    use {
        "glacambre/firenvim",
        run = function()
            vim.fn["firenvim#install"](0)
        end,
        config = function()
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
        end
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
        config = function()
            vim.g.Hexokinase_ftEnabled = {}
            vim.g.Hexokinase_highlighters = {"backgroundfull"}
            vim.g.Hexokinase_refreshEvents = {"TextChanged", "InsertLeave"}
            vim.g.Hexokinase_optInPatterns = {
                "full_hex", "triple_hex", "colour_names",
                "rgb", "rgba", "hsl", "hsla",
            }
        end
    }

    use { -- Markdown preview
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        cmd = "MarkdownPreview",
        run = function()
            vim.fn["mkdp#util#install"]()
        end,
    }

    use { -- Interactive Repls Over Neovim
        "hkupty/iron.nvim",
        config = function()
            local iron = require("iron")
            local iron_fts = require("iron.fts")

            iron.core.add_repl_definitions {
                python = {
                    django = {
                        command = {
                            "python", "manage.py", "shell_plus",
                            "--quiet-load", "--", "--no-autoindent"
                        },
                        format = iron_fts.python.ipython.format,
                    }
                },
            }

            iron.core.set_config {
                preferred = {
                    python = "ipython",
                },
                repl_open_cmd = "botright 12split",
            }

            vim.cmd("command! -nargs=1 IronReplName lua require('iron').core.repl_by_name(<f-args>)")
        end
    }

    --Plug "Asheq/close-buffers.vim"          " quickly close (bdelete) several buffers at once
    --Plug "dhruvasagar/vim-table-mode"       " automatic table creator & formatter

    --" to try:
    --" Plug "wellle/targets.vim"
    --" Plug "justinmk/vim-sneak"               " ? replaces s, but faster then f
    --" Plug "ripxorip/aerojump.nvim"

    -- Autocomplete
    -- use {
        --     "hrsh7th/nvim-compe",
        --     event = "InsertEnter",
        --     config = function()
            --         require("lv-compe").config()
        --     end
    -- }
    --" Git
    -- Status Line and Bufferline
    -- use {"glepnir/galaxyline.nvim"}

end

local plugins = setmetatable({}, {
    __index = function(_, key)
        if (key == "packer_bootstrap") then
            return packer_bootstrap
        end

        init()
        return packer[key]
    end
})

return plugins
