-- filetypes which may contain minified code
local min_ft = { "javascript", "css" }

local max_line_width = function(bufnr)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local output = vim.fn.system("wc -L " .. filename)
    return tonumber(output:match("%d+"))
end

local function is_big_file(bufnr, filesize_mib)
    if filesize_mib > 1 then
        return true
    end

    local filetype = vim.filetype.match({ buf = bufnr })

    if vim.list_contains(min_ft, filetype) then
        if max_line_width(bufnr) > 5000 then
            return true
        end
    end
end

return {
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        cmd = "MarkdownPreview",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        init = function()
            vim.g.undotree_WindowLayout = 2
        end,
    },

    {
        "catgoose/nvim-colorizer.lua",
        cmd = "ColorizerToggle",
        opts = {},
    },

    { --  automatically disables certain features if the opened file is big
        "LunarVim/bigfile.nvim",
        opts = {
            pattern = is_big_file,
        },
    },

    -- because sudo trick does not work on neovim.
    { "lambdalisue/suda.vim" },

    { "mizlan/iswap.nvim", cmd = "ISwap", opts = {} },

    { -- string inflection
        "farfanoide/inflector.vim",
        keys = {
            { "gI", "<Plug>(Inflect)", mode = { "v", "n" } },
        },
    },

    { -- pair programming
        "jbyuki/instant.nvim",
        optional = true,
        init = function()
            vim.g.instant_username = "Alexander"
        end,
    },

    { -- Google Translate
        "skanehira/translate.vim",
        cmd = "Translate",
        keys = {
            { "t", ":Translate", mode = "v" },
            { "<S-t>", ":Translate!", mode = "v" },
        },
        init = function()
            vim.g.translate_source = "en"
            vim.g.translate_target = "ru"
        end,
    },

    { "takac/vim-hardtime", cmd = "HardTimeToggle" },

    -- "dhruvasagar/vim-table-mode", -- automatic table creator & formatter
    -- "SCJangra/table-nvim"
}
