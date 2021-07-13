local M = {}

function M.nnoremap(bufnr, lhs, rhs)
    vim.api.nvim_buf_set_keymap(
        bufnr, "n", lhs, rhs, {noremap=true, silent=true}
    )
end

function M.isModuleAvailable(name)
    if package.loaded[name] then
        return true
    else
        for _, searcher in ipairs(package.searchers or package.loaders) do
            local loader = searcher(name)
            if type(loader) == 'function' then
                package.preload[name] = loader
                return true
            end
        end
        return false
    end
end

return M
