local map = vim.keymap.set

local function reopen_in_other_window(winnr)
    return function()
        local current_buf = vim.api.nvim_get_current_buf()
        local windows = vim.api.nvim_tabpage_list_wins(0)
        vim.api.nvim_set_current_win(windows[winnr])
        vim.api.nvim_win_set_buf(0, current_buf)
    end
end

local function is_qf_open()
    for _, win in ipairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            return true
        end
    end
    return false
end

-- https://github.com/junegunn/fzf.vim/issues/544
map("t", "<Esc>", '(&filetype == "fzf") ? "<Esc>" : "<C-\\><C-n>"', { expr = true })

-- inner line text obj
map({ "v", "o" }, "il", ":<C-u>normal! _vg_<CR>")

-- (de)indent using tab in normal and visual modes
map("n", "<Tab>", ">>_")
map("n", "<S-Tab>", "<<_")
map("v", "<Tab>", ">gv")
map("v", "<S-Tab>", "<gv")

-- search visually selected text
map("v", "/", '"fy/\\V<C-r>f<CR>')

-- last used buffer
map("n", "<Leader><Tab>", ":e#<CR>")
map("n", "<Leader>qq", ":qa<CR>")

-- +list (QuickFix/LocList)
map("n", "<Leader>lq", vim.cmd.copen)
map("n", "<Leader>ll", vim.cmd.lopen)
map("n", "<Leader>ln", function()
    return is_qf_open() and vim.cmd("cnext") or vim.cmd("lnext")
end)
map("n", "<Leader>lp", function()
    return is_qf_open() and (vim.cmd("cprev") or vim.cmd("clast")) or (vim.cmd("lprev") or vim.cmd("lfirst"))
end)
map("n", "<Leader>lc", function()
    return is_qf_open() and vim.cmd("cc") or vim.cmd("ll")
end)
map("n", "<Leader>ld", function()
    return is_qf_open() and vim.cmd("cclose") or vim.cmd("lclose")
end)

-- copy (save) loclist to qflist
map("n", "<Leader>es", ":call setqflist(getloclist(winnr()))<CR>")
-- parse diagnostic from the clipboard and send to qf
map("n", "<Leader>ep", ":DiagnosticFromClipboard<CR>")

-- +jump
map("n", "<Leader>jb", ":b bash<CR>")

-- +buffers
map("n", "<Leader>bq", ":copen<CR>")
map("n", "<Leader>bl", ":lopen<CR>")
map("n", "<Leader>bb", ":Buffers<CR>")
map("n", "<Leader>bm", ":messages<CR>")
map("n", "<Leader>bd", ":bd<CR>")
map("n", "<Leader>b<S-d>", ":b#|bd#<CR>", { silent = true })
map("n", "<Leader>bn", ":bnext<CR>")
map("n", "<Leader>bp", ":bprev<CR>")
map("n", "<Leader>b<S-n>", ":enew<CR>")

map("n", "<Leader>b1", reopen_in_other_window(1))
map("n", "<Leader>b2", reopen_in_other_window(2))
map("n", "<Leader>b3", reopen_in_other_window(3))
map("n", "<Leader>b4", reopen_in_other_window(4))

-- window selection
map("n", "<Leader>1", ":1wincmd w<CR>")
map("n", "<Leader>2", ":2wincmd w<CR>")
map("n", "<Leader>3", ":3wincmd w<CR>")
map("n", "<Leader>4", ":4wincmd w<CR>")

-- +project
map("n", "<Leader>pf", ":Files<CR>")
map("n", "<Leader>po", ":e notes.md<CR>")
map("n", "<Leader>pq", ":e .queries.sql<CR>")
map("n", "<Leader>pr", ":ProjectRoot<CR>")
map("n", "<Leader>pt", ":botright 12split +terminal | startinsert<CR>")

-- +tabs
map("n", "<Leader>tn", ":tabnext<CR>")
map("n", "<Leader>tp", ":tabprev<CR>")
map("n", "<Leader>td", ":tabclose<CR>")
map("n", "<Leader>t<S-n>", ":tabnew<CR>")

-- +windows
map("n", "<Leader>wd", "<C-w>c")
map("n", "<Leader>ws", "<C-w>s")
map("n", "<Leader>wv", "<C-w>v")
map("n", "<Leader>w=", "<C-w>=")

-- +files
map("n", "<Leader>fs", function()
    return vim.bo.readonly and vim.cmd("SudaWrite") or vim.cmd("update")
end)
map("n", "<Leader>fr", ":History<CR>")
map("n", "<Leader>f<S-r>", ":!rm %<CR>")

map("n", "<Leader>fm", function()
    local file = vim.fn.expand("%")
    return string.format(":!mv %s %s/", file, vim.fs.dirname(file))
end, { expr = true, desc = "Move current file" })

map("n", "<Leader>fc", function()
    local basedir = vim.fs.dirname(vim.fn.expand("%"))
    return string.format(":e %s/", basedir)
end, { expr = true, desc = "Edit file in the current directory" })

map("n", "<Leader>fd", function()
    vim.cmd.Files({ vim.fs.dirname(vim.fn.expand("%")) })
end, { desc = "Select file in the current directory" })

-- +files/edit
map("n", "<Leader>fev", function()
    vim.cmd.lcd({ vim.fs.dirname(vim.env.MYVIMRC) })
    vim.cmd.edit({ vim.fs.basename(vim.env.MYVIMRC) })
end)
map("n", "<Leader>feb", function()
    vim.cmd.lcd({ "~/.config/bash" })
    vim.cmd.edit({ "main.bash" })
end)

-- +files/yank
-- file name under cursor
map("n", "<Leader>fyc", ":let @+=expand('<cfile>')<CR>", { silent = true })
-- file name
map("n", "<Leader>fyn", ":let @+=expand('%:t')<CR>", { silent = true })
-- relative file name
map("n", "<Leader>fyy", ":let @+=expand('%:f')<CR>", { silent = true })
-- absolute file name
map("n", "<Leader>fy<S-y>", ":let @+=expand('%:p')<CR>", { silent = true })
-- relative file name with line number
map("n", "<Leader>fyl", ":let @+=expand('%:f') . ':' . line('.')<CR>", { silent = true })
-- absolute file name with line number
map("n", "<Leader>fy<S-l>", ":let @+=expand('%:p') . ':' . line('.')<CR>", { silent = true })

-- +search
map("n", "<Leader>sc", ":nohlsearch<CR>")
map("n", "<Leader>sa", ":RgRaw<Space>--<Space>''<Left>")
map("v", "<Leader>sa", ":RgSelectedFixedString<CR>")
map("n", "<Leader>sb", ":BLines<CR>")
map("n", "<Leader>sw", ":RgRawCurrentWord<CR>")
map("n", "<Leader>st", ":Tags<CR>")
map("n", "<Leader>s<S-t>", function()
    vim.cmd.Tags({ vim.fn.expand("<cword>") })
end)
map("n", "<Leader>sd", function()
    local search_term = vim.fn.input("> ")
    local directory = vim.fs.dirname(vim.fn.expand("%"))
    vim.cmd.RgRaw({ "--", search_term, directory })
end)
map("n", "<Leader>sp", ":Rg<CR>")
map("n", "<Leader>sg", function()
    vim.cmd.WebSearch({ vim.fn.expand("<cword>") })
end)
map("n", "<Leader>ds", ":DocumentSymbols<CR>")

-- +git
map("n", "<Leader>gb", ":Gitsigns blame<CR>")
map("n", "<Leader>gha", ":Gitsigns stage_hunk<CR>")
map("n", "<Leader>ghu", ":Gitsigns reset_hunk<CR>")
map("n", "<Leader>ghn", ":Gitsigns next_hunk<CR>")
map("n", "<Leader>ghp", ":Gitsigns prev_hunk<CR>")
map("n", "<Leader>ghs", ":Gitsigns stage_buffer<CR>")
