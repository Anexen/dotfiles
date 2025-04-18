local function show_lint_progress(callback)
    vim.diagnostic.config({ underline = false })
    local poll = require("fidget.poll")
    local progress = require("fidget.progress")
    local lint = require("lint")

    local handle = progress.handle.create({
        title = "Linting",
        lsp_client = { name = "nvim-lint" },
    })

    local poller = poll.Poller({
        name = "Linting",
        poll = function()
            local linters = lint.get_running()
            if #linters > 0 then
                handle:report({ message = table.concat(linters, ", ") })
                return true
            else
                handle:finish()
                pcall(callback)
                return false
            end
        end,
    })

    poller:start_polling(25)
end

vim.api.nvim_create_user_command("Lint", function(args)
    local prg = args.args or nil

    local callback = function()
        vim.fn.setloclist(0, {}) -- clear loclist
        vim.diagnostic.setloclist({ open = false })
    end
    require("lint").try_lint(prg)
    show_lint_progress(callback)
end, {
    nargs = "?",
    complete = function()
        return { "dmypy", "mypy", "pylint", "ruff", "eslint", "hadolint", "tfsec", "jq" }
    end,
})

return {
    "mfussenegger/nvim-lint",
}
