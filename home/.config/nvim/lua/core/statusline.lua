-- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html

-- vim.opt.fillchars = "stl:―,stlnc:―"

local function hl(content, group)
    return string.format("%%#%s#%s%%*", group, content)
end

local function winwidth()
    return vim.api.nvim_win_get_width(0)
end

local Sections = {}

function Sections.window_number()
    return " " .. vim.api.nvim_win_get_number(0) .. " "
end

function Sections.file_path()
    local path = winwidth() > 100 and "%f" or "%.40f"
    return " " .. path .. " "
    -- local root_directory = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    -- return string.format(" (%s) %s ", root_directory, path)
end

function Sections.file_format()
    if winwidth() > 70 then
        local eol = vim.bo.fileformat
        if eol ~= "" and eol ~= "unix" then
            return "[%{&fileformat}]"
        end
    end

    return ""
end

function Sections.file_encoding()
    if winwidth() > 70 then
        local encoding = vim.bo.fileencoding or vim.bo.encoding
        if encoding ~= "" and encoding ~= "utf-8" then
            return "[%{&fileencoding}]"
        end
    end

    return ""
end

function Sections.diagnostic(severity)
    return " ●" .. #vim.diagnostic.get(0, { severity = severity })
end

function Sections.vcs()
    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.head == "" then
        return ""
    end

    local added = git_info.added and ("%#GitSignsAdd#+" .. git_info.added) or ""
    local changed = git_info.changed and ("%#GitSignsChange#~" .. git_info.changed) or ""
    local removed = git_info.removed and ("%#GitSignsDelete#-" .. git_info.removed) or ""

    return table.concat({
        " ",
        added,
        changed,
        removed,
        " ",
        "%#Normal# ",
        git_info.head,
        " %#Normal#",
    })
end

local StatusLine = {}

---@return string
function StatusLine.active()
    local current_mode = vim.api.nvim_get_mode().mode
    local active_hl = "StatusLineActiveNormalMode"

    if current_mode == "i" or current_mode == "ic" or current_mode == "t" then
        active_hl = "StatusLineActiveInsertMode"
    elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
        active_hl = "StatusLineActiveVisualMode"
    elseif current_mode == "R" then
        active_hl = "StatusLineActiveReplaceMode"
    end

    return table.concat({
        hl(Sections.window_number(), active_hl),
        hl(Sections.file_path(), "StatusLineTextItalic"),
        "%m", -- modified
        "%r", -- readonly
        Sections.file_format(),
        Sections.file_encoding(),
        -- Sections.vcs(),
        hl("%=", "WinSeparator"),
        hl(Sections.diagnostic(vim.diagnostic.severity.ERROR), "DiagnosticSignError"),
        hl(Sections.diagnostic(vim.diagnostic.severity.WARN), "DiagnosticSignWarn"),
        hl(Sections.diagnostic(vim.diagnostic.severity.INFO), "DiagnosticSignInfo"),
        hl(" %2.p%% ", "StatusLineText"),
        hl(" %3.l:%-2.c ", active_hl),
    })
end

---@return string
function StatusLine.inactive()
    return table.concat({
        hl(Sections.window_number(), "StatusLineInactiveMode"),
        hl(Sections.file_path(), "StatusLineTextItalic"),
        "%m",
        "%r",
    })
end

local statusline_group = vim.api.nvim_create_augroup("statusline", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "DiagnosticChanged" }, {
    group = statusline_group,
    callback = function()
        vim.wo.statusline = "%!v:lua.require('core.statusline').active()"
    end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = statusline_group,
    callback = function()
        -- use simplified syntax because inactive line has no moving parts
        vim.wo.statusline = StatusLine.inactive()
    end,
})

return StatusLine
