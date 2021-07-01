local nvim_lsp = require('lspconfig')

local setup_keybindings = function(client, bufnr)
    local function nnoremap(lhs, rhs)
        vim.api.nvim_buf_set_keymap(
            bufnr, "n", lhs, rhs, {noremap=true, silent=true}
            )
    end

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    nnoremap('gD', ':lua vim.lsp.buf.declaration()<CR>')
    nnoremap('gd', ':lua vim.lsp.buf.definition()<CR>')
    nnoremap('K', ':lua vim.lsp.buf.hover()<CR>')
    nnoremap('<C-k>', ':lua vim.lsp.buf.signature_help()<CR>')
    nnoremap('<LocalLeader>R', ':lua vim.lsp.buf.rename()<CR>')
    nnoremap('<LocalLeader>e', ':lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
    nnoremap('<LocalLeader>gi', ':lua vim.lsp.buf.implementation()<CR>')
    nnoremap('<LocalLeader>gt', ':lua vim.lsp.buf.type_definition()<CR>')
    nnoremap('<LocalLeader>gr', ':lua vim.lsp.buf.references()<CR>')
    nnoremap('<LocalLeader>q', ':lua vim.lsp.diagnostic.set_loclist()<CR>')
    nnoremap('<LocalLeader>ca', ':lua vim.lsp.buf.code_action()<cr>')
    nnoremap('<LocalLeader>cl', ':lua vim.lsp.buf.code_lens()<CR>')
    nnoremap("<LocalLeader>cf", ":lua vim.lsp.buf.formatting()<CR>")
end


nvim_lsp.pyls.setup {
    on_attach = setup_keybindings,
    settings = {
    }
}

-- paru -S deno
nvim_lsp.denols.setup{
    on_attach = setup_keybindings,
    init_options = {
        enable = true,
        lint = true,
        unstable = true
    }
}

-- paru -S sqls
-- It causes vim to pause a second when it quits.
-- complition not working
-- Error when running :SqlsExecuteQuery with line visual selection
-- nvim_lsp.sqls.setup{
--     on_attach = function(client, bufnr)
--         setup_keybindings(client, bufnr)
--         client.resolved_capabilities.execute_command = true
--         require"sqls".setup{picker = "fzf"}
--     end,
-- }
