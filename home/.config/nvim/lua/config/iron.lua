local iron = require("iron")
local iron_fts = require("iron.fts")

iron.core.add_repl_definitions {
    python = {
        django = {
            command = {
                "python", "manage.py", "shell_plus",
                "--quiet-load", "--", "--no-autoindent"
            },
            format = iron_fts.python.ipython.format,
        }
    },
}

iron.core.set_config {
    preferred = {
        python = "ipython",
    },
    repl_open_cmd = "botright 12split",
}

vim.cmd("command! -nargs=1 IronReplName lua require('iron').core.repl_by_name(<f-args>)")
