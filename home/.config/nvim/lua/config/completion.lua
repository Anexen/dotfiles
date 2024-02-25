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

local underscore_compare = function(entry1, entry2)
    local _, entry1_under = entry1.completion_item.label:find "^_+"
    local _, entry2_under = entry2.completion_item.label:find "^_+"
    entry1_under = entry1_under or 0
    entry2_under = entry2_under or 0
    if entry1_under > entry2_under then
        return false
    elseif entry1_under < entry2_under then
        return true
    end
end


require("cmp_ai.config"):setup({
  max_lines = 30,
  provider = "llamacpp",
  provider_options = {
    -- base_url = "http://192.168.99.90:8080/completion",
    base_url = "http://localhost:8080/completion",
    prompt = function(lines_before, lines_after)
      return "<PRE> " .. lines_before .. " <SUF>" .. lines_after .. " <MID>"
      -- return "<fim_prefix>" .. lines_before .. "<fim_suffix>" .. lines_after .. "<fim_middle>"
    end,
  },
  notify = true,
  notify_callback = function(msg)
    require("fidget").notify(msg)
  end,
  run_on_every_keystroke = false,
  ignored_file_types = {
    html = true
    -- default is not to ignore
    -- uncomment to ignore in lua:
    -- lua = true
  },
})

cmp.setup {
    sources = {
        { name = 'vsnip' },
        {
            name = 'nvim_lsp',
            priority = 100
        },
        {
            name = 'buffer',
            priority = 99,
            -- trigger_characters = {"."},
            max_item_count = 10,
            option = { get_bufnrs = get_bufnrs }
        },
        {
            name = 'tags',
            priority = 98,
            -- trigger_characters = {"."},
            max_item_count = 10
        },
        {
            name = 'path',
            max_item_count = 25
        },
        {
            name = 'vim-dadbod-completion',
            priority = 100
        },
    },
    sorting = {
      comparators = {
        require("cmp_ai.compare"),
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
                cmp_ai = '[AI]',
            })[entry.source.name]
            return vim_item
        end
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end,
    },
    mapping = {
        ['<C-Space>'] = cmp.mapping.complete({}),
        -- ['<C-e>'] = cmp.mapping.close(),
        ['<Tab>'] = cmp.mapping(
            cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            {'i'}
        ),
        ['<S-Tab>'] = cmp.mapping(
            cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            {'i'}
        ),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ['<C-x>'] = cmp.mapping(
            cmp.mapping.complete({
                config = {
                    sources = cmp.config.sources({{ name = 'cmp_ai' }}),
                },
            }),
            { 'i' }
        ),
    },
}

vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
    pattern = "Cargo.toml",
    callback = function()
        cmp.setup.buffer({ sources = { { name = "crates" } } })
    end,
})
