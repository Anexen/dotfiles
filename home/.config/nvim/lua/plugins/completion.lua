local source_names = {
    buffer = "[Buf]",
    nvim_lsp = "[LSP]",
    path = "[Path]",
    tags = "[Tag]",
    otter = "[LSP]",
}

local function get_bufnrs()
    -- returns buf numbers for small visible buffers
    local bufs = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local line_count = vim.api.nvim_buf_line_count(buf)
        local byte_size = vim.api.nvim_buf_get_offset(buf, line_count)
        if byte_size < 1024 * 1024 then -- < 1mb
            bufs[buf] = true
        end
    end
    return vim.tbl_keys(bufs)
end

local underscore_compare = function(entry1, entry2)
    local _, entry1_under = entry1.completion_item.label:find("^_+")
    local _, entry2_under = entry2.completion_item.label:find("^_+")
    entry1_under = entry1_under or 0
    entry2_under = entry2_under or 0
    if entry1_under > entry2_under then
        return false
    elseif entry1_under < entry2_under then
        return true
    end
end

local cmp_setup = function()
    local cmp = require("cmp")
    local compare = require("cmp.config.compare")
    local lsp_kind_symbols = require("core.lspkind")

    cmp.setup({
        sources = {
            { name = "vsnip", priority = 1000 },
            { name = "nvim_lsp", priority = 100 },
            {
                name = "buffer",
                priority = 99,
                max_item_count = 10,
                option = { get_bufnrs = get_bufnrs },
            },
            { name = "tags", priority = 98, max_item_count = 10 },
            { name = "path", max_item_count = 25 },
            { name = "vim-dadbod-completion", priority = 100 },
        },
        sorting = {
            priority_weight = 1,
            comparators = {
                compare.score,
                compare.exact,
                -- compare.offset,
                compare.locality,
                underscore_compare,
                compare.kind,
                compare.order,
            },
        },
        formatting = {
            expandable_indicator = true,
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                vim_item.kind = lsp_kind_symbols[vim_item.kind]
                vim_item.menu = source_names[entry.source.name]
                return vim_item
            end,
        },
        snippet = {
            expand = function(args)
                vim.snippet.expand(args.body)
            end,
        },
        mapping = {
            ["<C-Space>"] = cmp.mapping.complete({}),
            ["<C-e>"] = cmp.mapping.close(),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                elseif vim.snippet.active({ direction = 1 }) then
                    vim.snippet.jump(1)
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                elseif vim.snippet.active({ direction = -1 }) then
                    vim.snippet.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
    })
end

vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
    pattern = "Cargo.toml",
    callback = function()
        require("cmp.config").set_buffer(
            { sources = { { name = "crates" } } },
            vim.api.nvim_get_current_buf() --
        )
    end,
})

vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("CmpSourceOtter", { clear = true }),
    pattern = { "*.md" },
    callback = function()
        require("cmp.config").set_buffer(
            { sources = { { name = "otter", priority = 100 } } },
            vim.api.nvim_get_current_buf() --
        )

        require("otter").activate(
            -- table of embedded languages to look for.
            -- nil will activate any embedded languages found
            { "python", "bash" },
            -- is completion enabled
            true,
            -- is diagnostics enabled
            false,
            -- treesitter query to look for embedded languages.
            -- uses injections if nil or not set.
            nil
        )
    end,
})

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/vim-vsnip",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "quangnguyen30192/cmp-nvim-tags",
        { "tpope/vim-dadbod", ft = "sql" },
        { "kristijanhusak/vim-dadbod-completion", ft = "sql" },
        { "jmbuhr/otter.nvim", ft = "markdown" },
    },
    init = function()
        vim.o.completeopt = "menuone,noselect"
        vim.o.pumheight = 20

        vim.g.vsnip_snippet_dir = vim.fn.expand("~/.config/nvim/snippets")
    end,
    config = function()
        cmp_setup()
        require("otter").setup()
    end,
}
