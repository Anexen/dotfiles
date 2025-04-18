local function make_import_stmt(path, symbol)
    path = path:gsub("%.py$", ""):gsub("[/\\]", ".")
    return string.format("from %s import %s", path, symbol)
end

local function find_site_packages_paths()
    local code = [[
import site, os
print(*site.getsitepackages(), os.path.dirname(os.__file__), sep="\n")
]]
    return vim.fn.systemlist("python -", code)
end

local function generate_site_packages_tags()
    -- TODO: fidget progress

    for _, path in ipairs(find_site_packages_paths()) do
        local tag_file = path .. "/tags"

        vim.fn.system({
            "ctags",
            "--recurse=yes", -- recursive
            "--languages=python",
            "--fields=+Z", -- include scope field
            "--kinds-python=cfv", -- class,function,variable
            "--exclude=test",
            "--exclude=tests",
            "--tag-relative=always", --  filename relative to tag file
            "-f",
            tag_file,
            path,
        })

        -- remove non top-level tags (tags with scope)
        vim.fn.system({ "sed", "-i", "/\tscope:/d", tag_file })
    end

    vim.notify("Done")
end

local function do_global_import(import_path)
    vim.cmd("normal ggO" .. import_path)
end

local function do_local_import(import_path)
    local prev_indent = vim.fn.indent(".")
    vim.cmd("normal [m")
    local next_indent = vim.fn.indent(".")

    if prev_indent == next_indent then
        -- we are at class level
        vim.cmd("normal \\<C-o>O" .. import_path)
    else
        vim.cmd("normal o" .. import_path)
    end
end

---@param symbol string
---@param scope 'function'|'file'
local function auto_import(symbol, scope)
    local tag_files = vim.iter(vim.fn.tagfiles())
        :map(function(tag_file)
            return vim.fn.fnamemodify(tag_file, ":h")
        end)
        :filter(function(tag_file)
            return tag_file ~= "."
        end)
        :totable()

    local sources = vim.iter(vim.fn.taglist("\\C^" .. symbol .. "$"))
        :filter(function(tag) -- only top-level tags
            return tag.scope == nil
        end)
        :map(function(tag) -- create import stmt from tag
            local path = tag.filename

            for _, tag_file in ipairs(tag_files) do
                if path:sub(0, #tag_file) == tag_file then
                    path = path:sub(#tag_file + 2)
                end
            end

            return make_import_stmt(path, tag.name)
        end)
        :totable()

    if #sources == 0 then
        vim.api.nvim_echo({ { "[AutoImport] Not found!", "WarningMsg" } }, true, {})
    end

    ---@diagnostic disable-next-line: cast-local-type
    sources = vim.fn.uniq(sources)

    local import_fn
    if scope == "function" then
        import_fn = do_local_import
    else
        import_fn = do_global_import
    end

    if #sources == 1 then
        import_fn(sources[1])
        return
    end

    local fzf_opts = {
        source = sources,
        sink = import_fn,
    }

    vim.call("fzf#run", vim.call("fzf#wrap", fzf_opts))
end

vim.opt_local.tagfunc = nil -- disable vim.lsp.tagfunc

vim.api.nvim_buf_create_user_command(0, "GenerateSitePackagesTags", generate_site_packages_tags, {})

local map_local = vim.keymap.set_local

-- +import
map_local("n", "<LocalLeader>iy", function()
    local path = vim.fn.expand("%:f")
    local symbol = vim.fn.expand("<cword>")
    vim.fn.setreg("+", make_import_stmt(path, symbol))
end, { desc = "Yank current symbol import stmt" })

map_local("n", "<LocalLeader>ip", function()
    auto_import(vim.fn.expand("<cword>"), "function")
end, { desc = "Local import" })

map_local("n", "<LocalLeader>i<S-p>", function()
    auto_import(vim.fn.expand("<cword>"), "file")
end, { desc = "Global import" })

-- +formatting
map_local("n", "<LocalLeader>ii", ":Format isort<CR>")
map_local("n", "<LocalLeader>f", ":Format black<CR>")

-- +linting
map_local("n", "<LocalLeader>lm", ":Lint mypy<CR>")
map_local("n", "<LocalLeader>lp", ":Lint pylint<CR>")

-- quickly insert breakpoint() statement
map_local("n", "<LocalLeader>db", "Obreakpoint()<Esc>")

-- run pytest
map_local("n", "<LocalLeader>tt", ":Pytest file<CR>")
map_local("n", "<LocalLeader>tf", ":Pytest function<CR>")
