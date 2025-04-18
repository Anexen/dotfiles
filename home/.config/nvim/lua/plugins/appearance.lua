
-- lua =require("onedarkpro.helpers").get_preloaded_colors()
local highlights = {
    ["@variable"] = { fg = "NONE" },
    ["@variable.javascript"] = { link = "@variable" },
    ["@variable.rust"] = { link = "@variable" },
    ["@variable.typescript"] = { link = "@variable" },
    ["@function.macro.rust"] = { link = "@function.macro" },
    ["@field.rust"] = { link = "@field" },
    ["@include.python"] = { link = "@include" },
    ["@markup.raw"] = { fg = "NONE" },
    -- ["@constructor.python"] = { link = "@constructor"},

    Conceal = { fg = "${gray}" },

    CursorLineNr = { fg = "${blue}" },

    SpellBad = { style = "underline" },
    SpellCap = { style = "underline" },
    SpellLocal = { style = "underline" },
    SpellRare = { style = "underline" },

    StatusLine = { fg = "${gray}", style = "bold" },
    StatusLineNC = { fg = "${gray}" },
    StatusLineActiveNormalMode = { fg = "${black}", bg = "${green}", style = "bold" },
    StatusLineActiveInsertMode = { fg = "${black}", bg = "${blue}", style = "bold" },
    StatusLineActiveVisualMode = { fg = "${black}", bg = "${purple}", style = "bold" },
    StatusLineActiveReplaceMode = { fg = "${black}", bg = "${red}", style = "bold" },
    StatusLineInactiveMode = { fg = "${black}", bg = "${yellow}", style = "bold" },
    StatusLineExtensionSection = { fg = "${purple}" },
    StatusLineText = { fg = "${white}" },
    StatusLineTextItalic = { fg = "${white}", style = "italic" },
}

return {
    --- colorscheme
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000,
        config = function()
            require("onedarkpro").setup({
                highlights = highlights,
                styles = {
                    comments = "italic",
                },
                options = {
                    transparency = true,
                },
            })

            vim.cmd("colorscheme onedark")
        end,
    },

    -- progress notifications
    {
        "j-hui/fidget.nvim",
        opts = {
            progress = {
                display = {
                    progress_icon = {
                        pattern = "arc",
                    },
                },
            },
            notification = {
                window = { winblend = 0 },
            },
        },
    },

    -- Pretty Quickfix window
    { "yorickpeterse/nvim-pqf", event = "VeryLazy", opts = {} },

    -- Edit entries in QuickFix window
    { "stefandtw/quickfix-reflector.vim" },

    -- handle :line:column in file path
    { "wsdjeg/vim-fetch" },
}
