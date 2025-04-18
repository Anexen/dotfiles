require("bootstrap")

-- Leader/LocalLeader - lazy.nvim needs these set first
vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("core")

require("lazy").setup({
    spec = "plugins",
    change_detection = { notify = false },
    install = { colorscheme = { "default" } },
})

require("lsp")
require("commands")
require("keymaps")

if vim.g.neovide then
    require("neovide")
end
