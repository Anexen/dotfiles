local o = vim.opt

-- always show some lines after the cursor
o.scrolloff = 5
o.sidescrolloff = 5
-- Display a confirmation dialog when closing an unsaved file
o.confirm = true
-- do not automatically wrap
o.wrap = false
-- show line numbers
o.number = true
-- Show line number on the current line and relative numbers on all other lines.
o.relativenumber = true
-- Any buffer can be hidden (keeping its changes) without first writing the buffer to a file
o.hidden = true
-- Turn tabs into spaces and
o.softtabstop = 4
-- vim.o.them to be 4 spaces long
o.tabstop = 4
-- New lines inherit the indentation of previous lines.
o.autoindent = true
-- Convert tabs to spaces.
o.expandtab = true
-- When shifting lines, round the indentation to the nearest multiple of shiftwidth
o.shiftround = true
-- When shifting, indent using four spaces.
o.shiftwidth = 4
-- Insert "tabstop" number of spaces when the “tab” key is pressed.
o.smarttab = true
-- show results of substition as they're happening
o.inccommand = "nosplit"
-- highlight the current line of the buffer
o.cursorline = true
-- always work with system clipboard
o.clipboard = "unnamedplus"
-- allow the mouse to be used to change cursor position
o.mouse = "a"
-- New splits open to right and bottom
o.splitright = true
o.splitbelow = true
-- case insensitive searching
o.ignorecase = true
-- case-sensitive if expresson contains a capital letter
o.smartcase = true
-- Ignore files matching these patterns when opening files based on a glob pattern.
o.wildignore:append(".pyc", ".swp")
-- enable local .vimrc
o.exrc = true
-- security limitations for local .vimrc files not owned by me
o.secure = true
-- always show sign column
o.signcolumn = "yes"
-- use dot to show a space.
o.listchars:append("space:·")
-- Maintain undo history between sessions
o.undofile = true
o.backup = false

o.updatetime = 250

o.foldmethod = "expr"

o.foldenable = false

o.termguicolors = true

o.background = "dark"

o.langmap = table.concat({
    "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz",
}, ",")

