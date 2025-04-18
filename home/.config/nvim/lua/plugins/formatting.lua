local function init_progress(msg)
    return require("fidget.progress").handle.create({
        title = "Formatting",
        message = msg,
        lsp_client = { name = "conform" },
    })
end

vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end

    local formatters = nil
    if args.args ~= "" then
        formatters = { args.args }
    end

    local msg = table.concat(formatters or require("conform").list_formatters_for_buffer(), ", ")
    local handle = init_progress(msg)

    require("conform").format({
        async = true,
        lsp_format = "fallback",
        range = range,
        formatters = formatters,
    }, function(err)
        handle:finish()
        if err then
            vim.notify(err, vim.log.levels.WARN, { title = "fmt" })
        end
    end)
end, {
    range = true,
    nargs = "?",
    complete = function()
        return require("conform").list_formatters_for_buffer()
    end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = "*",
    callback = function()
        require("conform").format({
            async = false,
            formatters = { "trim_whitespace" },
        })
    end,
})

return {
    "stevearc/conform.nvim",
    init = function()
        vim.o.formatexpr = "v:lua.require('conform').formatexpr({'timeout_ms':2000})"
    end,
    keys = {
        { "<LocalLeader>=", ":Format<CR>" },
    },
    opts = {
        formatters_by_ft = {
            ["*"] = { "trim_whitespace" },
            python = { "isort", "black" },
            sql = { "sqruff" },
            rust = { "rustfmt" },
            lua = { "stylua" },
            toml = { "taplo" },
            json = { "prettier" }, -- fixjson? jq?
            hurl = { "hurlfmt" },
            terraform = { "terraform_fmt" },
            hcl = { "hcl" },
            css = { "prettier" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            yaml = { "prettier" },
        },
    },
}
