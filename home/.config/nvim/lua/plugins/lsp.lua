
local lsp_installer = require("nvim-lsp-installer")
local nvim_lsp = require("lspconfig")
local utils = require("utils")

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
    nnoremap('<LocalLeader>ee', ':lua vim.diagnostic.open_float()<CR>')
    nnoremap('<LocalLeader>el', ':lua vim.diagnostic.setloclist()<CR>')
    nnoremap('<LocalLeader>en', ':lua vim.diagnostic.goto_next()<CR>')
    nnoremap('<LocalLeader>ep', ':lua vim.diagnostic.goto_prev()<CR>')
    nnoremap('<LocalLeader>gi', ':lua vim.lsp.buf.implementation()<CR>')
    nnoremap('<LocalLeader>gt', ':lua vim.lsp.buf.type_definition()<CR>')
    nnoremap('<LocalLeader>gr', ':lua vim.lsp.buf.references()<CR>')
    nnoremap('<LocalLeader>ca', ':lua vim.lsp.buf.code_action()<cr>')
    nnoremap("<LocalLeader>cf", ":lua vim.lsp.buf.formatting()<CR>")
end

function M.on_attach(client, bufnr)
    M.setup_keybindings(client, bufnr)

    if utils.isModuleAvailable("lsp_signature") then
        require"lsp_signature".on_attach {
            bind = true,
            hint_enable = false,
            handler_opts = { border = "single" }
        }
    end
end


lsp_installer.on_server_ready(function(server)
    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

    if server.name == "rust_analyzer" then return SetupRust(server) end
    if server.name == "sumneko_lua" then return SetupLua(server) end
    if server.name == "cssls" then return SetupCSS(server) end

    local others = {"vimls", "bashls", "gopls", "terraformls"}

    if vim.tbl_contains(others, server.name) then
        return server:setup { on_attach = M.on_attach }
    end

    error("Unknown language server: " .. server.name)
end)

-- :LspIntall dockerfile
-- nvim_lsp.dockerfile.setup{
--     on_attach = M.on_attach,
--     root_dir = function(fname)
--         return lsp_util.root_pattern("Dockerfile")(fname)
--             or lsp_util.root_pattern("dockerfiles")(fname)
--             or lsp_util.path.dirname(fname)
--     end;
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

function SetupRust(server)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
        }
    }

    local opts = server:get_default_options()
    opts.on_attach = M.on_attach
    opts.capabilities = capabilities
    opts.settings = {
        ["rust-analyzer"] = {
            cargo = {
                loadOutDirsFromCheck = true,
                allFeatures = true,
            },
            procMacro = {
                enable = true
            },
            diagnostics = {
                disabled = {"unresolved-proc-macro"}
            }
        }
    }

    local tools = {
        inlay_hints = {
            only_current_line = true
        }
    }

    -- server:setup {
    --     on_attach = M.on_attach,
    --     capabilities = capabilities,
    --     settings = settings
    -- }
    require("rust-tools").setup({server = opts, tools = tools})
end


function SetupLua(server)
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    server:setup {
        on_attach = M.on_attach,
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
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
end


-- :LspInstall css
function SetupCSS(server)
    -- vscode-css-language-server only provides completions when snippet support is
    -- enabled. To enable completion, install a snippet plugin and add the following
    -- override to your language client capabilities during setup.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    server:setup {
        on_attach = M.on_attach,
        capabilities = capabilities,
    }
end

-- :LspIntall typescript
-- enable per project
-- nvim_lsp.typescript.setup { on_attach = M.on_attach }


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

return M
