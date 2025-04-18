---@generic T
---@param items T[]
---@param opts table
---@param on_choice fun(item: T|nil, idx: integer|nil)
return function(items, opts, on_choice)
    -- Convert items to displayable strings and keep a map back to original
    local item_map = {}
    local source = {}

    for i, item in ipairs(items) do
        local format_item = opts.format_item or tostring
        local display = string.format("%s. %s", i, format_item(item))
        item_map[display] = { index = i, original = item }
        table.insert(source, display)
    end

    local fzf_opts = {
        source = source,
        sink = function(selected)
            local info = item_map[selected]
            if info then
                on_choice(info.original, info.index)
            else
                on_choice(nil, nil)
            end
        end,
        options = { "--prompt", (opts.prompt or "") .. "> " },
    }

    vim.call("fzf#run", vim.call("fzf#wrap", fzf_opts))
end
