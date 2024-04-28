return {
	-- Theme
	{
		"olimorris/onedarkpro.nvim",
		priority = 1000, -- Ensure it loads first
		opts = {
			highlights = {
				["@variable"] = { fg = "NONE" },
				["@variable.javascript"] = { link = "@variable" },
				["@variable.rust"] = { link = "@variable" },
				["@variable.typescript"] = { link = "@variable" },
				["@function.macro.rust"] = { link = "@function.macro" },
				["@field.rust"] = { link = "@field" },
				["@include.python"] = { link = "@include" },
				["@markup.raw"] = { fg = "NONE" },
				-- ["@constructor.python"] = { link = "@constructor"},
				CursorLineNr = { fg = "${blue}" },
				SpellBad = { style = "underline" },
				SpellCap = { style = "underline" },
				SpellLocal = { style = "underline" },
				SpellRare = { style = "underline" },
			},
			styles = {
				comments = "italic",
			},
			options = {
				bold = false,
				italic = true, -- Use the themes opinionated italic styles?
				underline = true, -- Use the themes opinionated underline styles?
				undercurl = true, -- Use the themes opinionated undercurl styles?
				transparency = true, -- Use a transparent background?
				terminal_colors = true,
				highlight_inactive_windows = true,
			},
		},
		config = function(_, opts)
			require("onedarkpro").setup(opts)
			vim.cmd("colorscheme onedark")
		end,
	},

    {
        "LunarVim/bigfile.nvim",
        opts = {},
    },
	-- Status Line and Bufferline
	-- {
	--     "glepnir/galaxyline.nvim",
	--     config = function() require'plugins.galaxyline' end,
	-- },

	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/nvim-treesitter-context",
			-- "CKolkey/ts-node-action",
			"yioneko/nvim-yati", -- fix indents
			"JoosepAlviste/nvim-ts-context-commentstring", -- setting the commentstring option based on the cursor location in the file
			{ "windwp/nvim-ts-autotag", ft = { "html", "xml" } }, -- autoclose and autorename html tag
		},
		build = ":TSUpdate",
		config = function()
			require("config.treesitter")
		end,
	},

	{
		"hashivim/vim-terraform",
		ft = "terraform",
		init = function()
			vim.g.terraform_fmt_on_save = 1
		end,
	},

	-- Git
	{
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufRead",
		opts = {},
	},

	{ "tpope/vim-fugitive", event = "BufRead" },
	{ "junegunn/gv.vim", cmd = "GV" },

	-- Search
	{
		"junegunn/fzf.vim",
		dependencies = {
			"junegunn/fzf",
			"jesseleite/vim-agriculture",
		},
		init = function()
			vim.g["agriculture#rg_options"] = "--smart-case"
			vim.g["fzf_layout"] = {
				window = { width = 1, height = 0.4, xoffset = 0, yoffset = 1, border = "sharp" },
			}
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"kosayoda/nvim-lightbulb",
			"gfanto/fzf-lsp.nvim",
			-- "ray-x/lsp_signature.nvim",
            "mrcjkb/rustaceanvim",
            "lvimuser/lsp-inlayhints.nvim",
            { "j-hui/fidget.nvim", event = "LspAttach" },
		},
		config = function()
			require("config.lsp")
		end,
	},

	{
		"saecki/crates.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		ft = "toml",
		opts = {},
	},

	{ -- displays latest package versions in package.json file as virtual text.
		"vuki656/package-info.nvim",
		ft = "json",
		opts = {},
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
            "hrsh7th/vim-vsnip",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"quangnguyen30192/cmp-nvim-tags",
			{ "tpope/vim-dadbod", ft = "sql" },
			{ "kristijanhusak/vim-dadbod-completion", ft = "sql" },
            { "jmbuhr/otter.nvim", ft = "markdown"},
		},
		config = function()
			require("config.completion")
		end,
	},

	-- Linters and Fixers
	{ "neomake/neomake" },
	-- { dir = "~/projects/neomake" },
	{ "sbdchd/neoformat" },

    {
        "alfredodeza/pytest.vim",
        ft = "python"
    },

    {
        "andythigpen/nvim-coverage",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = {"Coverage", "CoverageLoadLcov"},
        opts = {
            auto_reload = true,
            lcov_file = "coverage.lcov",
        }
    },

	-- Miscellaneous
	"stefandtw/quickfix-reflector.vim", -- edit entries in QuickFix window
	{ "yorickpeterse/nvim-pqf", event = "VeryLazy", opts = {} },

	{ "mizlan/iswap.nvim", cmd = "ISwap", opts = {} },
	"farfanoide/inflector.vim", -- string inflection

	-- show marks in sign column
	{ "kshenoy/vim-signature", event = "VeryLazy" },
	{ "takac/vim-hardtime", cmd = "HardTimeToggle" },
	{ "tweekmonster/startuptime.vim", cmd = "StartupTime" },

	{ -- because sudo trick does not work on neovim.
		"lambdalisue/suda.vim",
		init = function()
			vim.g.suda_smart_edit = 1
		end,
	},

	{ -- generate tags in background
		"ludovicchabant/vim-gutentags",
		config = function()
			vim.g.gutentags_generate_on_new = 0
			vim.g.gutentags_generate_on_missing = 0
			vim.g.gutentags_generate_on_write = 1

			-- extra project roots
			vim.g.gutentags_project_root = { "Cargo.toml", ".git" }
			vim.g.gutentags_add_default_project_roots = 1

			vim.g.gutentags_ctags_extra_args = { "--languages=python,rust,typescript" }
			vim.g.gutentags_ctags_exclude = {
				".git",
				".tox",
				".mypy_cache",
				".ipynb_checkpoints",
				"__pycache__",
				"*.min.js",
				"target",
			}
		end,
	},

	{
		"majutsushi/tagbar",
		cmd = "TagbarToggle",
		init = function()
			vim.g.tagbar_sort = 0
			vim.g.tagbar_foldlevel = 0
			vim.g.tagbar_autofocus = 1
			vim.g.tagbar_compact = 1
		end,
	},

	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		init = function()
			vim.g.undotree_WindowLayout = 2
		end,
	},

	{
		"jbyuki/instant.nvim",
		optional = true,
		init = function()
			vim.g.instant_username = "Alexander"
		end,
	},

	{ -- changes working directory to the project root
		"ahmedkhalf/project.nvim",
		main = "project_nvim",
		opts = {
			manual_mode = true,
			detection_methods = { "pattern" },
			patterns = {
				".python-version",
				"Cargo.toml",
				"=site-packages",
				".git",
				"init.vim",
			},
		},
	},

	{
		"glacambre/firenvim",
		cond = not not vim.g.started_by_firenvim,
		build = function()
			require("lazy").load({ plugins = "firenvim", wait = true })
			vim.fn["firenvim#install"](0)
		end,
		init = function()
			vim.g.firenvim_config = {
				localSettings = {
					[".*"] = {
						cmdline = "neovim",
						priority = 0,
						selector = "textarea",
						takeover = "never",
					},
				},
			}
		end,
	},

	{ -- Google Translate
		"skanehira/translate.vim",
		cmd = "Translate",
		init = function()
			vim.g.translate_source = "en"
			vim.g.translate_target = "ru"
		end,
	},

	{
		"terrortylor/nvim-comment",
		main = "nvim_comment",
		opts = {
			marker_padding = true,
			comment_empty = true,
			line_mapping = "<leader>cl",
			operator_mapping = "<leader>c",
			hook = function()
				require("ts_context_commentstring.internal").update_commentstring()
			end,
		},
	},

	{ -- colorizer
		"rrethy/vim-hexokinase",
		build = "make hexokinase",
		cmd = "HexokinaseToggle",
		init = function()
			vim.g.Hexokinase_ftEnabled = {}
			vim.g.Hexokinase_highlighters = { "backgroundfull" }
			vim.g.Hexokinase_refreshEvents = { "TextChanged", "InsertLeave" }
			vim.g.Hexokinase_optInPatterns = {
				"full_hex",
				"triple_hex",
				"colour_names",
				"rgb",
				"rgba",
				"hsl",
				"hsla",
			}
		end,
	},

	{ -- Markdown preview
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		cmd = "MarkdownPreview",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

    "dhruvasagar/vim-table-mode", -- automatic table creator & formatter

	-- { -- Interactive Repls Over Neovim
	--     "hkupty/iron.nvim",
	--     config = function() require"config.iron" end,
	--     optional = true,
	-- }
}
