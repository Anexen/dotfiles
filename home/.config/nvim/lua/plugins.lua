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

    -- Status Line and Bufferline
    -- use {"glepnir/galaxyline.nvim"}

    use {
        "nvim-treesitter/nvim-treesitter",
        -- disable = true,
        run = ":TSUpdate",
        requires = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            {"romgrk/nvim-treesitter-context", cmd = "TSContextToggle"},
        },
        config = function() require"plugins.treesitter" end
    }

    -- Git
    use {
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        event = "BufRead",
        config = function() require("gitsigns") end
    }
    use {"tpope/vim-fugitive", event = "BufRead"}
    use {"junegunn/gv.vim", cmd = "GV"}

    -- Search
    use {
        "junegunn/fzf.vim",
        requires = {"junegunn/fzf"}
    }
    use {
        "jesseleite/vim-agriculture",
        config=function()
            vim.g["agriculture#rg_options"] = "--smart-case"
        end
    }

    -- LSP
    use {
        "neovim/nvim-lspconfig",
        config = function() require"plugins.lsp" end,
        requires = {"kabouzeid/nvim-lspinstall"}
    }
    use {
        "hrsh7th/nvim-compe",
        event = "InsertEnter",
        requires = {
            {"tpope/vim-dadbod", ft="sql"},
            {"kristijanhusak/vim-dadbod-completion", ft="sql"},
        },
        config = function() require"plugins.completion" end
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
        config = function() require"plugins.tags" end,
        requires = { {"majutsushi/tagbar", cmd = "TagbarToggle"} }
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
        config = function() require"plugins.rooter" end,
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
        opt = true,
        config = function() require"plugins.iron" end
    }

    --Plug "Asheq/close-buffers.vim"          " quickly close (bdelete) several buffers at once
    --Plug "dhruvasagar/vim-table-mode"       " automatic table creator & formatter

    --" to try:
    --" Plug "wellle/targets.vim"
    --" Plug "justinmk/vim-sneak"               " ? replaces s, but faster then f
    --" Plug "ripxorip/aerojump.nvim"


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
