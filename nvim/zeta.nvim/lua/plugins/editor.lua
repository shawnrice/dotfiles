local M = {}

table.insert(M, {
	"folke/zen-mode.nvim",
	event = "VeryLazy",
	keys = {
		{ "<leader>zz", "<cmd>ZenMode<cr>", desc = "Toggle ZenMode" },
	},
	window = {
		width = 160,
		height = 1,
		options = {
			colorcolumn = "", -- hide the color column
		},
	},
	plugins = {
		opts = {
			ruler = false,
			showcmd = false,
			laststatus = 0,
			gitsigns = { enabled = false },
			todo = { enabled = false },
		},
	},
})

-- @see https://github.com/Owen-Dechow/videre.nvim
-- Explores JSON in a weird way

-- @see https://github.com/shortcuts/no-neck-pain.nvim
table.insert(M, {
	"shortcuts/no-neck-pain.nvim",
	version = "*",
	opts = {},
})

table.insert(M, { "nvim-mini/mini.nvim", version = "*" })

table.insert(M, {
	"jiaoshijie/undotree",
	dependencies = { "nvim-lua/plenary.nvim" },
	---@module 'undotree.collector'
	---@type UndoTreeCollector.Opts
	opts = {
		float_diff = false, -- using float window previews diff, set this `true` will disable layout option
		layout = "left_bottom", -- "left_bottom", "left_left_bottom"
		position = "left", -- "right", "bottom"
		ignore_filetype = {
			"undotree",
			"undotreeDiff",
			"qf",
			"TelescopePrompt",
			"spectre_panel",
			"tsplayground",
		},
		window = {
			winblend = 30,
			diff_panel_height = 10, -- or whatever height you prefer
		},
		keymaps = {
			j = "move_next",
			k = "move_prev",
			gj = "move2parent",
			J = "move_change_next",
			K = "move_change_prev",
			["<cr>"] = "action_enter",
			p = "enter_diffbuf",
			q = "quit",
		},
	},
	keys = { -- load the plugin only when using it's keybinding:
		{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
	},
})

table.insert(M, {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	---@module "ibl"
	---@type ibl.config
	opts = {
		scope = {
			enabled = true,
			show_start = true, -- underline the start of the scope
			show_end = true, -- underline the end of the scope
			-- char = "│", -- Only show the active scope line
			char = "▏", -- or try: "│", "▏", "▎", "▍", "▌", "▋", "▊", "▉"
			highlight = { "Whitespace", "NonText" },
			include = {
				node_type = {
					["*"] = {
						"case_statement",
						"switch_statement",
						"case_clause",
						"default_clause",
					},
				},
			},
		},
		indent = {
			char = "▏", -- Hide regular indent guides with invisible char
			highlight = { "NonText" },
		},
		whitespace = {
			highlight = { "Whitespace", "NonText" },
		},
	},
})

-- Plugin to show which functions / blocks you're in
-- @see https://github.com/nvim-treesitter/nvim-treesitter-context
table.insert(M, {
	"nvim-treesitter/nvim-treesitter-context",
	opts = {
		enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
		multiwindow = false, -- Enable multiwindow support.
		max_lines = 4, -- How many lines the window should span. Values <= 0 mean no limit.
		min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
		line_numbers = true,
		multiline_threshold = 20, -- Maximum number of lines to show for a single context
		trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
		mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
		-- Separator between context and content. Should be a single character string, like '-'.
		-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
		separator = nil,
		zindex = 20, -- The Z-index of the context window
		on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
	},
})

-- @see https://github.com/cshuaimin/ssr.nvim
-- Structural search and replace
table.insert(M, {
	"cshuaimin/ssr.nvim",
	opts = {
		border = "rounded",
		min_width = 50,
		min_height = 5,
		max_width = 120,
		max_height = 25,
		adjust_window = true,
		keymaps = {
			close = "q",
			next_match = "n",
			prev_match = "N",
			replace_confirm = "<cr>",
			replace_all = "<leader><cr>",
		},
	},
	keys = {
		{ "<leader>sr", "<cmd>lua require('ssr').open()<cr>" },
	},
})

-- Todo: this should go somewhere more language specific
-- @see https://github.com/dmmulroy/ts-error-translator.nvim

return M
