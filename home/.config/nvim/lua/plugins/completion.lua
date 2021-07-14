vim.o.completeopt = "menuone,noselect"
vim.o.pumheight = 20

vim.cmd('inoremap <silent><expr> <C-Space> compe#complete()')
vim.cmd('inoremap <expr> <Tab> pumvisible() ? "<C-n>" : "<Tab>"')
vim.cmd('inoremap <expr> <S-Tab> pumvisible() ? "<C-p>" : "<S-Tab>"')

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
        vim_dadbod_completion = true,
    };
}
