-- Dynamic options

local agroup = vim.api.nvim_create_augroup("Appearance", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = agroup,
    desc = "highlight on yank",
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = agroup,
    pattern = { "*.txt" },
    desc = "Open help window in a vertical split to the right",
    callback = function()
        if vim.o.filetype == "help" then
            vim.cmd.wincmd("L")
        end
    end,
})

vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
    group = agroup,
    desc = "Show cursorline for active window",
    callback = function()
        vim.opt_local.cursorline = true
    end,
})

vim.api.nvim_create_autocmd("WinLeave", {
    group = agroup,
    desc = "Hide cursorline for inactive window",
    callback = function()
        vim.opt_local.cursorline = false
    end,
})

-- utility commands

vim.api.nvim_create_user_command("WebSearch", function(args)
    local query = table.concat(args.fargs, "+")
    os.execute('xdg-open "https://www.google.com/search?q=' .. query .. '"')
end, { nargs = "?", desc = "Open selected text in the browser" })

vim.api.nvim_create_user_command("CopyCodeBlock", function(opts)
    local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, true)
    local content = table.concat(lines, "\n")
    local result = string.format("```%s\n%s\n```", vim.bo.filetype, content)
    vim.fn.setreg("+", result)
    vim.notify("Text copied to clipboard")
end, { range = true, desc = "Copy text to clipboard using codeblock format" })

vim.api.nvim_create_user_command("DiagnosticFromClipboard", function()
    -- Get clipboard lines
    ---@diagnostic disable-next-line: redundant-parameter
    local lines = vim.fn.getreg("+", 1, true)

    local qf_items = {}

    ---@diagnostic disable-next-line: param-type-mismatch
    for _, line in ipairs(lines) do
        -- Match: "path/to/file.py:123: message text"
        local filename, lnum, text = line:match("^([^:]+):(%d+):%s*(.+)$")
        if filename and lnum and text then
            table.insert(qf_items, {
                filename = filename,
                lnum = tonumber(lnum),
                text = text,
            })
        end
    end

    if vim.tbl_isempty(qf_items) then
        vim.notify("No valid entries found in clipboard", vim.log.levels.WARN)
        return
    end

    vim.fn.setqflist(qf_items, "r") -- 'r' = replace existing list
    vim.cmd("copen")
end, { desc = "Populate qf from clipboard" })
