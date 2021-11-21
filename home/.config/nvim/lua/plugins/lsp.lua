-- important. creates servers in lspconfig
-- server name must match name in lspinstall
-- :LspIntall python -> nvim_lsp.python.setup(), not nvim_lsp.pyls
require'lspinstall'.setup()

local nvim_lsp = require'lspconfig'
local utils = require'utils'

local M = {}

vim.lsp.handlers["textDocument/references"] = vim.lsp.with(
    vim.lsp.handlers["textDocument/references"], {
        -- Use location list instead of quickfix list
        loclist = true,
    }
)

-- local goto_definition = vim.lsp.handlers["textDocument/definition"];

-- vim.lsp.handlers["textDocument/definition"] = function(
--     err, method, result, client_id, bufnr, config
-- )
--     print(vim.inspect(result))
--     return goto_definition(err, method, result, client_id, bufnr, config)
-- end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = true,
        virtual_text = {
            spacing = 2,
            prefix = "❯"
        },
        underline = false,
        update_in_insert = false,
    }
)

-- customize signs
vim.cmd [[
sign define LspDiagnosticsSignError text=● texthl=LspDiagnosticsSignError linehl= numhl=
sign define LspDiagnosticsSignWarning text=● texthl=LspDiagnosticsSignWarning linehl= numhl=
sign define LspDiagnosticsSignInformation text=● texthl=LspDiagnosticsSignInformation linehl= numhl=
sign define LspDiagnosticsSignHint text=● texthl=LspDiagnosticsSignHint linehl= numhl=
]]


function M.setup_keybindings(_, bufnr)
    local nnoremap = function(lhs, rhs) utils.nnoremap(bufnr, lhs, rhs) end

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    nnoremap('gD', ':lua vim.lsp.buf.declaration()<CR>')
    nnoremap('gd', ':lua vim.lsp.buf.definition()<CR>')
    nnoremap('K', ':lua vim.lsp.buf.hover()<CR>')
    nnoremap('<C-k>', ':lua vim.lsp.buf.signature_help()<CR>')
    nnoremap('<LocalLeader>R', ':lua vim.lsp.buf.rename()<CR>')
    nnoremap('<LocalLeader>ee', ':lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
    nnoremap('<LocalLeader>el', ':lua vim.lsp.diagnostic.set_loclist()<CR>')
    nnoremap('<LocalLeader>en', ':lua vim.lsp.diagnostic.goto_next()<CR>')
    nnoremap('<LocalLeader>ep', ':lua vim.lsp.diagnostic.goto_prev()<CR>')
    nnoremap('<LocalLeader>gi', ':lua vim.lsp.buf.implementation()<CR>')
    nnoremap('<LocalLeader>gt', ':lua vim.lsp.buf.type_definition()<CR>')
    nnoremap('<LocalLeader>gr', ':lua vim.lsp.buf.references()<CR>')
    nnoremap('<LocalLeader>ca', ':lua vim.lsp.buf.code_action()<cr>')
    nnoremap("<LocalLeader>cf", ":lua vim.lsp.buf.formatting()<CR>")
end

function M.on_attach(client, bufnr)
    M.setup_keybindings(client, bufnr)

    if utils.isModuleAvailable("lsp_signature") then
        require"lsp_signature".on_attach{
            bind = true,
            hint_enable = false,
            handler_opts = { border = "single" }
        }
    end
end

-- :LspIntall dockerfile
-- nvim_lsp.dockerfile.setup{
--     on_attach = M.on_attach,
--     root_dir = function(fname)
--         return lsp_util.root_pattern("Dockerfile")(fname)
--             or lsp_util.root_pattern("dockerfiles")(fname)
--             or lsp_util.path.dirname(fname)
--     end;
-- };

-- :LspIntall bash
nvim_lsp.bash.setup{ on_attach = M.on_attach }


-- :LspInstall python
-- pyright under the hood
-- very slow and memory hungry
-- nvim_lsp.python.setup{
--     on_attach = setup_keybindings,
-- };

nvim_lsp.pylsp.setup {
    on_attach = M.on_attach,
    -- available settings at https://github.com/python-lsp/python-lsp-server/blob/develop/pylsp/config/schema.json
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = { enabled = false },
                pylint = { enabled = false },
                yapf = { enabled = false },
            }
        }
    }
}

local function make_rust_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
        }
    }
    return capabilities
end

nvim_lsp.rust_analyzer.setup {
    on_attach = M.on_attach,
    capabilities = make_rust_capabilities(),
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                loadOutDirsFromCheck = true,
                allFeatures = true,
            },
            procMacro = {
                enable = true
            },
        }
    }
}

nvim_lsp.terraformls.setup { on_attach = M.on_attach }

-- :LspInstall vim
nvim_lsp.vim.setup { on_attach = M.on_attach }

-- :LspInstall lua

local function lua_runtime_path()
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    return runtime_path
end

nvim_lsp.lua.setup {
    on_attach = M.on_attach,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = lua_runtime_path(),
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

--: LspInstall css
local function make_css_capabilities()
    -- vscode-css-language-server only provides completions when snippet support is
    -- enabled. To enable completion, install a snippet plugin and add the following
    -- override to your language client capabilities during setup.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return capabilities
end

nvim_lsp.css.setup {
    capabilities = make_css_capabilities(),
    on_attach = M.on_attach
}

-- :LspIntall typescript
-- enable per project
-- nvim_lsp.typescript.setup { on_attach = M.on_attach }

-- paru -S deno
-- nvim_lsp.denols.setup{
--     on_attach = M.setup_keybindings,
--     init_options = {
--         enable = true,
--         lint = true,
--         unstable = true
--     }
-- }

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
-- wrap setup() into setup_servers() function
-- require'lspinstall'.post_install_hook = function ()
--   setup_servers() -- reload installed servers
--   vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
-- end

return M
