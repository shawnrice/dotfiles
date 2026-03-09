local M = {}

table.insert(M, {
	"nvim-tree/nvim-tree.lua",
	config = function()
		require("nvim-tree").setup({
			hijack_directories = {
				enable = false, -- Don't hijack directory opening
			},
			disable_netrw = false, -- Don't disable netrw completely
			hijack_netrw = false, -- Don't replace netrw
			sync_root_with_cwd = true,
			respect_buf_cwd = true,
			update_focused_file = {
				enable = true,
				update_root = true,
			},
			view = {
				float = {
					enable = true,
					open_win_config = {
						relative = "editor",
						border = "rounded",
						width = math.floor(vim.o.columns * 0.7), -- 70% width
						height = math.floor(vim.o.lines * 0.8), -- 80% height
						row = math.floor(vim.o.lines * 0.1), -- Centered
						col = math.floor(vim.o.columns * 0.15), -- Centered
					},
				},
			},
			renderer = {
				indent_width = 2,
				root_folder_label = ":~:s?$?/..?",
				icons = {
					show = {
						folder_arrow = true,
					},
				},
			},
			filters = {
				dotfiles = false,
				git_clean = false,
				no_buffer = false,
			},
			git = {
				enable = true,
				ignore = false,
			},
			actions = {
				open_file = {
					quit_on_open = true, -- Close tree when you select a file
					window_picker = {
						enable = false,
					},
				},
			},
		})
		vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")
	end,
})

table.insert(M, {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		default_file_explorer = false,
	},
	keys = {
		{ "<leader>o", "<cmd>Oil<cr>", desc = "Open Oil (parent dir)" },
	},
	priority = 49,
	dependencies = { { "nvim-mini/mini.icons", version = "*" } },
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
})

-- @see https://github.com/rmagatti/auto-session
table.insert(M, {
	"rmagatti/auto-session",
	lazy = false,
	keys = {
		{ "<leader>wr", "<cmd>AutoSession search<CR>", desc = "Session search" },
		{ "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session" },
		{ "<leader>wa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
	},
	priority = 1000,

	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		auto_save = true,
		auto_restore = true,
		purge_after_minutes = 43200,
		show_auto_restore_notif = true,
		continue_restore_on_error = true,
		legacy_cmds = false,
		git_use_branch_name = true,
		git_auto_restore_on_branch_change = true,

		log_level = "info",

		pre_restore_cmds = {
			function()
				vim.g.session_restoring = true
			end,
		},

		post_restore_cmds = {
			function()
				vim.g.session_restored = true
				vim.g.session_restoring = false
			end,
		},

		save_extra_cmds = {
			function()
				print("Auto-saving session for: " .. vim.fn.getcwd())
				return true
			end,
		},

		bypass_session_save_file_types = {
			"alpha",
			"dashboard",
			"gitcommit",
			"gitrebase",
			"lazy",
			"mason",
			"neo-tree",
			"nvim-tree",
			"oil",
			"Trouble",
		},

		suppressed_dirs = { "~/", "~/projects", "~/Desktop", "~/Downloads", "/" },

		-- The following are already the default values, no need to provide them if these are already the settings you want.
		session_lens = {
			picker = "fzf", -- "telescope"|"snacks"|"fzf"|"select"|nil
			mappings = {
				-- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
				delete_session = { "i", "<C-d>" },
				alternate_session = { "i", "<C-s>" },
				copy_session = { "i", "<C-y>" },
			},

			load_on_setup = false, -- only for telescope

			picker_opts = {
				-- For Fzf-Lua, picker_opts just turns into winopts, see:
				-- https://github.com/ibhagwan/fzf-lua#customization
				--
				height = 0.8,
				width = 0.50,
			},
		},
	},
})

table.insert(M, {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},
	keys = {
		{
			"<C-e>",
			"<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>",
			desc = "Toggle harpoon menu",
		},
	},
})

table.insert(M, {
	"bassamsdata/namu.nvim",
	opts = {
		global = {},
		namu_symbols = { -- Specific Module options
			options = {},
		},
	},
	keys = {
		{ "<leader>ss", ":Namu symbols<cr>", { desc = "Jump to LSP symbol", silent = true } },
		{ "<leader>sw", ":Namu workspace<cr>", { desc = "LSP Symbols - Workspace", silent = true } },
	},
})

-- Peek preview for definitions, references, implementations without losing context
table.insert(M, {
	"DNLHC/glance.nvim",
	cmd = "Glance",
	opts = {},
})

-- Persistent browsable results panel for diagnostics, references, symbols
table.insert(M, {
	"folke/trouble.nvim",
	cmd = "Trouble",
	opts = {},
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
		{ "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
		{ "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
		{
			"<leader>xr",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP refs/defs (Trouble)",
		},
		{ "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
	},
})

-- https://github.com/stevearc/aerial.nvim
table.insert(M, {
	"stevearc/aerial.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("aerial").setup({ -- optionally use on_attach to set keymaps when aerial has attached to a buffer
			layout = {
				-- These control the width of the aerial window.
				-- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				-- min_width and max_width can be a list of mixed types.
				-- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
				max_width = { 40, 0.75 },
				width = nil,
				min_width = 0.5,

				-- key-value pairs of window-local options for aerial window (e.g. winhl)
				win_opts = {},

				-- Determines the default direction to open the aerial window. The 'prefer'
				-- options will open the window in the other direction *if* there is a
				-- different buffer in the way of the preferred direction
				-- Enum: prefer_right, prefer_left, right, left, float
				-- default_direction = "float",
				default_direction = "prefer_left",

				-- Determines where the aerial window will be opened
				--   edge   - open aerial at the far right/left of the editor
				--   window - open aerial to the right/left of the current window
				-- placement = "window",
				placement = "edge",

				-- When the symbols change, resize the aerial window (within min/max constraints) to fit
				resize_to_content = true,

				-- Preserve window size equality with (:help CTRL-W_=)
				preserve_equality = false,
			},

			on_attach = function(bufnr)
				vim.keymap.set("n", "[a", "<cmd>AerialPrev<CR>", { buffer = bufnr })
				vim.keymap.set("n", "]a", "<cmd>AerialNext<CR>", { buffer = bufnr })
			end,
		})

		-- You probably also want to set a keymap to toggle aerial
		vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
	end,
})

table.insert(M, {
	"dmtrKovalenko/fff.nvim",
	build = function()
		-- this will download prebuild binary or try to use existing rustup toolchain to build from source
		-- (if you are using lazy you can use gb for rebuilding a plugin if needed)
		require("fff.download").download_or_build_binary()
	end,
	-- if you are using nixos
	-- build = "nix run .#release",
	opts = { -- (optional)
		debug = {
			enabled = true, -- we expect your collaboration at least during the beta
			show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
		},
	},
	-- No need to lazy-load with lazy.nvim.
	-- This plugin initializes itself lazily.
	lazy = false,
	keys = {
		{
			"ff", -- try it if you didn't it is a banger keybinding for a picker
			function()
				require("fff").find_files()
			end,
			desc = "FFFind files",
		},
		{
			"fg",
			function()
				require("fff").live_grep()
			end,
			desc = "LiFFFe grep",
		},
		{
			"fz",
			function()
				require("fff").live_grep({
					grep = {
						modes = { "fuzzy", "plain" },
					},
				})
			end,
			desc = "Live fffuzy grep",
		},
		{
			"fc",
			function()
				require("fff").live_grep({ query = vim.fn.expand("<cword>") })
			end,
			desc = "Search current word",
		},
	},
})

return M
