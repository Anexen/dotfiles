vim.g.omni_sql_no_default_maps = 1
vim.g.loaded_sql_completion = 0

-- Default database
local sql_default_database = "default"

local function list_connections(prefix)
    return vim.tbl_filter(function(name)
        return name:find(prefix)
    end, vim.tbl_keys(vim.g.databases or {}))
end

local function connect_to_database(alias)
    alias = alias or sql_default_database
    local conn = vim.g.databases[alias]
    if not conn then
        print("Connection " .. alias .. " is not defined.")
        return
    end
    vim.b.db = conn
    vim.fn["vim_dadbod_completion#fetch"](vim.api.nvim_get_current_buf())
end

local function send_lines(range_start, range_end)
    vim.fn.execute(range_start .. "," .. range_end .. "DB")
end
--
local function send_paragraph()
    local range_start = vim.fn.line("'{")
    local range_end = vim.fn.line("'}")
    send_lines(range_start, range_end)
end

local function send_query()
    local range_start = vim.fn.search("--{{", "bcn") + 1
    local range_end = vim.fn.search("--}}", "cn") - 1
    send_lines(range_start, range_end)
end

vim.api.nvim_buf_create_user_command(0, "DBConnect", function(args)
    connect_to_database(args.args)
end, {
    nargs = "?",
    complete = list_connections,
})

vim.api.nvim_buf_create_user_command(0, "DBSendQuery", send_query, {})

local map_local = vim.keymap.set_local

map_local("n", "<LocalLeader>s", send_query, { silent = true })
map_local("n", "<LocalLeader>p", send_paragraph, { silent = true })
