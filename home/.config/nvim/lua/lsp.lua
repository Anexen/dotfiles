vim.diagnostic.config({
    underline = false,
    update_in_insert = false,
    severity_sort = true,
    virtual_text = {
        spacing = 2,
        prefix = "❯",
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "●",
            [vim.diagnostic.severity.WARN] = "●",
            [vim.diagnostic.severity.INFO] = "●",
            [vim.diagnostic.severity.HINT] = "●",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
        },
    },
})

local M = {}

function M.setup_keybindings(_, bufnr)
    local nnoremap = function(lhs, rhs)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true })
    end

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    nnoremap("gD", vim.lsp.buf.declaration)
    nnoremap("gd", vim.lsp.buf.definition)
    nnoremap("K", vim.lsp.buf.hover)
    nnoremap("<C-k>", vim.lsp.buf.signature_help)
    nnoremap("<LocalLeader>R", vim.lsp.buf.rename)
    nnoremap("<LocalLeader>ee", vim.diagnostic.open_float)
    nnoremap("<LocalLeader>el", vim.diagnostic.setloclist)
    nnoremap("<LocalLeader>en", function()
        vim.diagnostic.jump({ count = 1 })
    end)
    nnoremap("<LocalLeader>ep", function()
        vim.diagnostic.jump({ count = -1 })
    end)
    nnoremap("<LocalLeader>gi", vim.lsp.buf.implementation)
    nnoremap("<LocalLeader>gt", vim.lsp.buf.type_definition)
    nnoremap("<LocalLeader>gr", vim.lsp.buf.references)
    nnoremap("<LocalLeader>ca", vim.lsp.buf.code_action)
    nnoremap("<LocalLeader>cf", vim.lsp.buf.format)
    nnoremap("<LocalLeader>cl", vim.lsp.codelens.run)
end

function M.setup_code_lens(client, bufnr)
    if not client.server_capabilities.codeLensProvider then
        return
    end

    local group = vim.api.nvim_create_augroup("LspCodeLensRefresh", {})

    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        group = group,
        buffer = bufnr,
        callback = function()
            vim.lsp.codelens.refresh({ bufnr = bufnr })
        end,
    })
end

function M.on_attach(client, bufnr)
    M.setup_keybindings(client, bufnr)
    -- M.setup_code_lens(client, bufnr)

    client.server_capabilities.semanticTokensProvider = nil

    -- do not set tagfunc to vim.lsp.tagfunc if the server doesn't support workspace/symbol request
    if not client.server_capabilities.workspaceSymbolProvider then
        vim.bo[bufnr].tagfunc = nil
    end

    -- client.capabilities.textDocument.completion.completionItem.snippetSupport = false
end

function M.default_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    -- enable LSP commands
    capabilities.workspace = capabilities.workspace or {}
    capabilities.workspace.executeCommand = { dynamicRegistration = true }

    -- enable code lens
    capabilities.textDocument.codeLens = { dynamicRegistration = true }

    return capabilities
end

vim.lsp.config("*", {
    on_attach = M.on_attach,
    root_markers = { ".git", ".editorconfig" },
    capabilities = M.default_capabilities(),
})

vim.lsp.config("pylsp", {
    -- available settings at https://github.com/python-lsp/python-lsp-server/blob/develop/pylsp/config/schema.json
    settings = {
        pylsp = {
            plugins = {
                ruff = { enabled = true },
                -- rope_autoimport = {
                --     enabled = true,
                --     completions = { enabled = false },
                --     code_actions = { enabled = true },
                --     memory = false,
                -- },
            },
        },
    },
})

vim.lsp.config("rust", {
    -- https://rust-analyzer.github.io/book/configuration.html
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                features = "all",
            },
            procMacro = {
                enable = true,
            },
            diagnostics = {
                disabled = {
                    "unresolved-proc-macro",
                    "macro-error",
                },
            },
            workspace = {
                symbol = {
                    search = {
                        scope = "workspace_and_dependencies",
                    },
                },
            },
            checkOnSave = {
                command = "clippy",
            },
        },
    },
})

vim.lsp.enable({
    "bashls",
    "cssls",
    "gopls",
    "lua_ls",
    "nginx_language_server",
    "nixd",
    "pylsp",
    "rust_analyzer",
    "terraformls",
    "ts_ls",
    "vimls",
})

return M
