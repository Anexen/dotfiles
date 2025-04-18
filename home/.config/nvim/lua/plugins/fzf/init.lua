return {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    init = function()
        vim.g.fzf_layout = {
            window = { width = 1, height = 0.4, xoffset = 0, yoffset = 1, border = "sharp" },
        }

        vim.g.fzf_action = {
            ["ctrl-t"] = "tab split",
            ["ctrl-x"] = "split",
            ["ctrl-v"] = "vsplit",
            ["ctrl-q"] = vim.fn["fzf#vim#listproc#quickfix"],
            ["ctrl-y"] = function(lines)
                vim.fn.setreg("*", table.concat(lines, "\n"))
            end,
        }
    end,
    config = function()
        vim.ui.select = require("plugins.fzf.picker")
        require("plugins.fzf.commands")
    end,
}
