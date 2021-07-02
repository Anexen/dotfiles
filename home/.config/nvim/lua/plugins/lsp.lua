-- important. patches cmd in lspconfig
require('lspinstall').setup()

local nvim_lsp = require('lspconfig')

local function setup_keybindings(client, bufnr)
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
    nnoremap("<LocalLeader>cf", ":lua vim.lsp.buf.formatting()<CR>")
end


nvim_lsp.pyls.setup {
    on_attach = setup_keybindings,
    settings = {
        pyls = {
            plugins = {
                pycodestyle = { enabled = false },
                pylint = { enabled = false },
                yapf = { enabled = false },
            }
        }
    }
}

-- :LspInstall lua
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp.sumneko_lua.setup {
    cmd = require("lspinstall/util").extract_config("lua").default_config.cmd,
    on_attach = setup_keybindings,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

-- paru -S typescript-language-server-bin
-- disabled in favour of deno
-- nvim_lsp.tsserver.setup{}

-- paru -S deno
nvim_lsp.denols.setup{
    on_attach = setup_keybindings,
    init_options = {
        enable = true,
        lint = true,
        unstable = true
    }
}

-- paru -S terraform-ls-bin
nvim_lsp.terraformls.setup{}

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

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
