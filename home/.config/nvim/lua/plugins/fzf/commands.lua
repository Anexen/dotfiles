local function list_buffers()
    return vim.iter(vim.fn.getbufinfo({ buflisted = 1 }))
        :filter(function(buf)
            return vim.api.nvim_buf_is_loaded(buf.bufnr)
        end)
        :map(function(buf)
            local name = buf.name ~= "" and vim.fn.fnamemodify(buf.name, ":~:.") or "[No Name]"
            local display = string.format("[%d] %s", buf.bufnr, name)
            return { display, buf.bufnr }
        end)
        :fold({}, function(acc, pair)
            acc[pair[1]] = pair[2]
            return acc
        end)
end

local function fzf_buf_delete()
    local bufnr_map = list_buffers()

    local fzf_opts = {
        source = vim.tbl_keys(bufnr_map),
        sinklist = function(selected)
            for _, item in ipairs(selected) do
                local bufnr = bufnr_map[item]
                if bufnr and vim.api.nvim_buf_is_loaded(bufnr) then
                    vim.api.nvim_buf_delete(bufnr, { force = false })
                end
            end
        end,
        options = { "--multi", "--prompt", "Delete buffer> " },
    }

    vim.call("fzf#run", vim.call("fzf#wrap", fzf_opts))
end

local function fzf_rg_raw(args)
    local cmd = "rg --column --line-number --no-heading --color=always --smart-case " .. table.concat(args, " ")
    vim.call("fzf#vim#grep", cmd, vim.call("fzf#vim#with_preview"), 0)
end

vim.api.nvim_create_user_command("BDelete", fzf_buf_delete, { desc = "FZF Buffer Delete" })

vim.api.nvim_create_user_command("RgRaw", function(opts)
    fzf_rg_raw(opts.fargs)
end, { nargs = "+", complete = "dir" })

vim.api.nvim_create_user_command("RgRawCurrentWord", function()
    fzf_rg_raw({ "-F", "--", vim.fn.expand("<cword>") })
end, {})

vim.api.nvim_create_user_command("RgSelectedFixedString", function()
    vim.cmd.normal('gv"ay')
    local selection = vim.fn.getreg("a"):gsub("\n+$", "")
    fzf_rg_raw({ "-F", "--", vim.fn.shellescape(selection) })
end, { range = true })

vim.api.nvim_create_user_command("DocumentSymbols", function()
    require("aerial").sync_load() -- lazy load aerial

    local fzf_opts = {
        source = require("aerial.fzf").get_labels(),
        sink = require("aerial.fzf").goto_symbol,
        options = { "--prompt", "Document symbols> " },
    }

    vim.call("fzf#run", vim.call("fzf#wrap", fzf_opts))
end, {})
