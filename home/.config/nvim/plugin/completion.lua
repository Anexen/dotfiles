
vim.o.completeopt = "menuone,noselect"
vim.o.pumheight = 20

require'compe'.setup {
    enabled = true,
    source = {
        path = true,
        buffer = true,
        tags = true,
        nvim_lsp = true,
        vim_dadbod_completion = true,
    };
}

vim.cmd('inoremap <silent><expr> <C-Space> compe#complete()')
vim.cmd('inoremap <expr> <Tab> pumvisible() ? "<C-n>" : "<Tab>"')
vim.cmd('inoremap <expr> <S-Tab> pumvisible() ? "<C-p>" : "<S-Tab>"')
