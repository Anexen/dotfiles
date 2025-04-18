
local function indent_guides_disable()
    vim.opt_local.list = false
    vim.cmd([[syntax clear Whitespace]])
    vim.b.indent_guides_enabled = false
end

local function indent_guides_enable()
    vim.opt_local.list = true

    vim.api.nvim_set_hl(0, "Whitespace", { link = "Conceal" })

    vim.cmd([[
    syntax clear Whitespace
    syntax match Whitespace / / containedin=ALL conceal cchar=·
    ]])

    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = 'c'

    vim.b.indent_guides_enabled = true
end

local function indent_guides_toggle()
    if vim.b["indent_guides_enabled"] then
        indent_guides_disable()
    else
        indent_guides_enable()
    end
end

vim.api.nvim_create_user_command("IndentGuides", indent_guides_toggle, {})

vim.keymap.set("n", "<Leader>mw", indent_guides_toggle, { silent = true })
