local mark_hl = "MarkSignHL"

local sign_group_name = "marks"

local marks = {}

---@type table<string, boolean>
local sign_cache = {}

local function is_lowercase_mark(mark)
    return 97 <= mark:byte() and mark:byte() <= 122
end

local function is_uppercase_mark(mark)
    return 65 <= mark:byte() and mark:byte() <= 90
end

local function is_letter_mark(mark)
    return is_lowercase_mark(mark) or is_uppercase_mark(mark)
end

---@param mark string
---@param bufnr integer
local function delete_mark(mark, bufnr)
    local buffer_marks = marks[bufnr]

    if not buffer_marks or not buffer_marks[mark] then
        return
    end

    -- Remove the sign.
    vim.fn.sign_unplace(sign_group_name, {
        buffer = bufnr,
        id = buffer_marks[mark].id,
    })
    buffer_marks[mark] = nil

    -- Remove the mark.
    vim.cmd("delmarks " .. mark)
end

---@param mark string
---@param bufnr integer
---@param line? integer
local function register_mark(mark, bufnr, line)
    local buffer_marks = marks[bufnr]

    if not buffer_marks then
        return
    end

    if buffer_marks[mark] then
        -- Mark already exists, remove it first.
        delete_mark(mark, bufnr)
    end

    -- Add the sign to the tracking table.
    local id = mark:byte() * 100
    line = line or vim.api.nvim_win_get_cursor(0)[1]
    buffer_marks[mark] = { line = line, id = id }

    -- Create the sign.
    local sign_name = "Marks_" .. mark
    if not sign_cache[sign_name] then
        vim.fn.sign_define(sign_name, { text = mark, texthl = mark_hl })
        sign_cache[sign_name] = true
    end

    vim.fn.sign_place(id, sign_group_name, sign_name, bufnr, {
        lnum = line,
        priority = 10,
    })
end

local function try_register_mark(mark, bufnr, mark_line)
    local cached_mark = marks[bufnr][mark]

    if not cached_mark or cached_mark.line ~= mark_line then
        register_mark(mark, bufnr, mark_line)
    end
end

---@param mark string
---@param bufnr integer
local function set_mark(mark, bufnr)
    register_mark(mark, bufnr)
    vim.cmd("normal! m" .. mark)
end

---@param bufnr integer
local function sync_marks(bufnr)
    -- Remove all marks that were deleted.
    for mark, _ in pairs(marks[bufnr]) do
        if vim.api.nvim_buf_get_mark(bufnr, mark)[1] == 0 then
            delete_mark(mark, bufnr)
        end
    end

    -- Register the letter marks (global)
    for _, data in ipairs(vim.fn.getmarklist()) do
        local mark = data.mark:sub(2, 3)
        local mark_buf, mark_line = unpack(data.pos)

        if is_uppercase_mark(mark) and mark_buf == bufnr then
            try_register_mark(mark, bufnr, mark_line)
        end
    end

    -- Register the letter marks (local)
    for _, data in ipairs(vim.fn.getmarklist(bufnr)) do
        local mark = data.mark:sub(2, 3)

        if is_lowercase_mark(mark) then
            try_register_mark(mark, bufnr, data.pos[2])
        end
    end
end

vim.keymap.set("n", "m", "", {
    desc = "Add mark",
    callback = function()
        local mark = vim.fn.getcharstr()

        if is_letter_mark(mark) then
            set_mark(mark, vim.api.nvim_get_current_buf())
        end
    end,
})

vim.keymap.set("n", "dm", "", {
    desc = "Delete mark",
    callback = function()
        local mark = vim.fn.getcharstr()
        if is_letter_mark(mark) then
            delete_mark(mark, vim.api.nvim_get_current_buf())
        end
    end,
})

vim.keymap.set("n", "dm-", "", {
    desc = "Delete all buffer marks",
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        marks[bufnr] = {}
        vim.fn.sign_unplace(sign_group_name, { buffer = bufnr })
        vim.cmd("delmarks!")
    end,
})

vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*",
    desc = "Show marks in sign column after opening buffer",
    callback = function(args)
        local bufnr = args.buf

        -- Only handle normal buffers.
        if vim.bo[bufnr].bt ~= "" then
            return true
        end

        if not marks[bufnr] then
            marks[bufnr] = {}
        end

        sync_marks(bufnr)
    end,
})
