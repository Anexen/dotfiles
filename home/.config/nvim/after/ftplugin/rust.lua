vim.api.nvim_buf_create_user_command(0, "CargoReload", function()
    local clients = vim.lsp.get_clients({ bufnr = 0, name = "rust_analyzer" })
    for _, client in ipairs(clients) do
        vim.notify("Reloading Cargo Workspace")
        client:request("rust-analyzer/reloadWorkspace", {}, function(err)
            if err then
                error(tostring(err))
            end
            vim.notify("Cargo workspace reloaded")
        end, 0)
    end
end, {})
