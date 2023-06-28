vim.o.completeopt = "menuone,noselect"
vim.o.pumheight = 20

local cmp = require('cmp')
local compare = require('cmp.config.compare')

local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
}

local function get_bufnrs()
    -- returns bufnr for small visible buffers
    local bufs = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
        if byte_size < 1024 * 1024 then -- < 1mb
            bufs[buf] = true
        end
    end
    return vim.tbl_keys(bufs)
end

cmp.setup {
    sources = {
        -- { name = 'vsnip' },
        { name = 'nvim_lsp', priority = 100 },
        { name = 'buffer', priority = 99, option = { get_bufnrs = get_bufnrs }},
        { name = 'tags', priority = 98 },
        { name = 'path' },
        { name = 'vim-dadbod-completion' },
    },
    sorting = {
      comparators = {
        compare.score,
        compare.exact,
        compare.kind,
        compare.offset,
        compare.recently_used,
        compare.locality,
        compare.order,
      },
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            -- This concatonates the icons with the name of the item kind
            vim_item.kind = kind_icons[vim_item.kind]
            -- Source
            vim_item.menu = ({
                buffer = "[Buf]",
                nvim_lsp = "[LSP]",
                path = "[Path]",
                tags = "[Tag]",
            })[entry.source.name]
            return vim_item
        end
    },
    mapping = {
        ['<C-Space>'] = cmp.mapping.complete({}),
        -- ['<C-e>'] = cmp.mapping.close(),
        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(
            { behavior = cmp.SelectBehavior.Insert }), {'i'}
        ),
        ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(
            { behavior = cmp.SelectBehavior.Insert }), {'i'}
        ),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
    },
}

vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
    pattern = "Cargo.toml",
    callback = function()
        cmp.setup.buffer({ sources = { { name = "crates" } } })
    end,
})
