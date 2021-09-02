vim.o.completeopt = "menuone,noselect"
vim.o.pumheight = 20

vim.cmd [[
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <expr> <Tab> pumvisible() ? "<C-n>" : "<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "<C-p>" : "<S-Tab>"
imap <expr> <C-e> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-e>'
]]

require'compe'.setup {
    enabled = true,
    source = {
        path = true,
        -- set buffer priority higher than tags
        buffer = {
            priority = 100
        },
        tags = {
            priority = 90
        },
        nvim_lsp = true,
        vim_dadbod_completion = {
            priority = 1000
        },
    };
}
