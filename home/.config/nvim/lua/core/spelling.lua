vim.cmd("syntax spell toplevel");

vim.cmd([[
iabbr fitler filter
iabbr calss class
iabbr imoprt import
iabbr improt import
iabbr yeidl yield
iabbr yeild yield
iabbr yiedl yield
]])

local function enable_spelling()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
    vim.opt_local.spelloptions = "camel"
    vim.opt_local.spellcapcheck = ""
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python", "javascript", "markdown", "rust", "lua" },
    callback = enable_spelling,
})
