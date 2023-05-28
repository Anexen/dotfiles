require("nvim-treesitter.configs").setup({
	-- Modules and its options go here
	ensure_installed = "all",
	highlight = { enable = true },
	incremental_selection = { enable = true },
	autotag = { -- windwp/nvim-ts-autotag plugin
		enable = true,
	},
	indent = { -- disable builtin indent module is favour to yati
		enable = false,
	},
	yati = { -- yioneko/nvim-yati
		enable = true,
	},
    context_commentstring = { -- JoosepAlviste/nvim-ts-context-commentstring
        enable = true,
        enable_autocmd = false,
    },
    textobjects = {
		select = {
			enable = true,
			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,
			-- You can use the capture groups defined in textobjects.scm
			keymaps = {
				["ab"] = "@block.outer",
				["ib"] = "@block.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
	},
})

require("treesitter-context").setup({
	enable = false,
})
