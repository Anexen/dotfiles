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
