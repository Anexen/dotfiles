require("mason").setup()
require("mason-lspconfig").setup()
require("fzf_lsp").setup()

local nvim_lsp = require("lspconfig")
local utils = require("utils")

local M = {}

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

vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

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
    client.server_capabilities.semanticTokensProvider = nil

    if utils.isModuleAvailable("lsp_signature") then
        require"lsp_signature".on_attach {
            bind = true,
            hint_enable = false,
            handler_opts = { border = "single" }
        }
    end
end

function M.on_init(client)
    if client.server_capabilities then
        -- disable LSP Semantic Tokens
        client.server_capabilities.semanticTokensProvider = false
    end
end

function M.root_pattern(...)
    return vim.fs.dirname(vim.fs.find({ ... }, { upward = true })[1])
end

nvim_lsp.util.default_config = vim.tbl_extend(
    "force",
    nvim_lsp.util.default_config,
    {
        -- on_init = M.on_init,
        on_attach = M.on_attach,
    }
)

nvim_lsp.vimls.setup {}
nvim_lsp.bashls.setup {}
nvim_lsp.gopls.setup {}
nvim_lsp.docker_compose_language_service.setup {}
nvim_lsp.terraformls.setup {}

-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = { 'terraform' },
--     callback = function()
--         vim.lsp.start({
--             name = 'terraformls',
--             cmd = { 'terraform-ls', 'serve' },
--             root_dir = M.root_pattern('.terraform', '.git'),
--         })
--     end,
-- })

-- vim.api.nvim_create_autocmd('LspAttach', {
--     callback = function(args)
--         M.on_attach(args.client, args.buf)
--     end
-- })

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
    -- available settings at https://github.com/python-lsp/python-lsp-server/blob/develop/pylsp/config/schema.json
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = { enabled = false },
                pylint = { enabled = false },
                yapf = { enabled = false },
                pylsp_mypy = { enabled = false },
            }
        }
    }
}

-- nvim_lsp.pyright.setup {
--     autostart = false,
-- }

local function SetupRust()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
        }
    }

    local opts = {}
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
            },
            workspace = {
                symbol = {
                    search = {
                        scope = "workspace_and_dependencies"
                    }
                }
            },
            inlayHints = {
                locationLinks = false,
                -- lifetimeElisionHints = { enable = "always" },
                -- reborrowHints = { enable = "always" },
            },
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


SetupRust()

function SetupLua(server)
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    server.setup {
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


SetupLua(nvim_lsp.lua_ls)

-- :LspInstall css
function SetupCSS(server)
    -- vscode-css-language-server only provides completions when snippet support is
    -- enabled. To enable completion, install a snippet plugin and add the following
    -- override to your language client capabilities during setup.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    server:setup {
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
