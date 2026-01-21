-- Main LSP plugin configuration
local M = {}

-- Mason setup
table.insert(M, {
	"williamboman/mason.nvim",
	opts = {
		ui = {
			border = "rounded",
			width = 0.8,
			height = 0.8,
		},
	},
	config = function()
		local language_configs = require("utils.language-configs")
		require("mason").setup({
			ensure_installed = vim.list_extend(
				language_configs.get_mason_lsp_servers(),
				language_configs.get_mason_tools()
			),
		})
	end,
})

table.insert(M, {
	"williamboman/mason-lspconfig.nvim",
	dependencies = { "williamboman/mason.nvim" },
	config = function()
		local language_configs = require("utils.language-configs")

		require("mason-lspconfig").setup({
			automatic_installation = true,
			ensure_installed = language_configs.get_mason_lsp_servers(),
		})
	end,
})

-- Neodev for Neovim Lua development
table.insert(M, {
	"folke/neodev.nvim",
	ft = "lua",
	opts = {
		library = {
			enabled = true,
			runtime = true,
			types = true,
			plugins = { "nvim-dap-ui" },
		},
		setup_jsonls = true,
		lspconfig = true,
	},
})

-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects

-- Treesitter
table.insert(M, {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local language_configs = require("utils.language-configs")

		-- Combine base parsers with language-specific ones
		local ensure_installed = vim.list_extend(
			{ "lua", "vim", "vimdoc", "query", "json", "yaml", "toml", "markdown" },
			language_configs.get_treesitter_parsers()
		)

		require("nvim-treesitter.configs").setup({
			ensure_installed = ensure_installed,
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
})

-- Conform for formatting
table.insert(M, {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	-- cmd = { "ConformInfo" },  -- Removed this line so Conform loads eagerly
	config = function()
		local language_configs = require("utils.language-configs")

		-- Combine base formatters with language-specific ones
		local formatters_by_ft = vim.tbl_extend("force", {
			lua = { "stylua" },
			json = { "prettierd" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },
		}, language_configs.get_formatters())

		require("conform").setup({
			formatters_by_ft = formatters_by_ft,
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		})
	end,
})

-- Blink completion
table.insert(M, {
	"saghen/blink.cmp",
	lazy = false,
	dependencies = {
		"rafamadriz/friendly-snippets",
		"neovim/nvim-lspconfig",
	},
	version = "v0.*",
	opts = {
		keymap = { preset = "default" },
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
			menu = {
				draw = {
					columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
				},
			},
		},
		signature = { enabled = true },
	},
})

-- LSP Configuration (Neovim 0.11+ style)
table.insert(M, {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"folke/neodev.nvim",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- Configure LSP floating windows
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
			max_width = 80,
		})

		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "rounded",
		})

		vim.diagnostic.config({
			float = { border = "rounded" },
			virtual_text = { prefix = "●" },
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		-- Function to enhance server config with workspace settings
		local function enhance_server_config(server_name, config)
			config = config or {}

			-- Add Blink capabilities
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)

			-- Enhance with workspace config if available
			if server_name == "vtsls" and vim.g.workspace_typescript_config then
				local ws = vim.g.workspace_typescript_config
				config.settings = config.settings or {}
				config.settings.typescript = vim.tbl_deep_extend("force", config.settings.typescript or {}, {
					tsdk = ws.tsdk,
					preferences = ws.preferences or {},
					tsserver = { maxTsServerMemory = ws.maxTsServerMemory or 6144 },
				})
				if vim.g.workspace_root_dir_func then
					config.root_dir = vim.g.workspace_root_dir_func
				end
			end

			if server_name == "eslint" and vim.g.workspace_eslint_config then
				local ws = vim.g.workspace_eslint_config
				config.settings = vim.tbl_deep_extend("force", config.settings or {}, ws)
				if vim.g.workspace_root_dir_func then
					config.root_dir = vim.g.workspace_root_dir_func
				end
			end

			return config
		end

		-- Configure and enable servers using Neovim 0.11+ API
		local language_configs = require("utils.language-configs")
		local server_configs = language_configs.get_server_configs()

		for server_name, server_config in pairs(server_configs) do
			-- Configure the server with enhanced settings
			local config = enhance_server_config(server_name, server_config)
			vim.lsp.config(server_name, config)

			-- Enable the server (will start when appropriate filetypes are opened)
			vim.lsp.enable(server_name)
		end

		-- Key mappings for LSP
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>f", function()
					require("conform").format({ lsp_fallback = true })
				end, opts)
			end,
		})
	end,
})

-- Fidget for LSP progress
table.insert(M, {
	"j-hui/fidget.nvim",
	event = "LspAttach",
	opts = {
		notification = {
			window = {
				winblend = 100,
			},
		},
	},
})

-- Garbage Day for LSP memory management
table.insert(M, {
	"zeioth/garbage-day.nvim",
	dependencies = "neovim/nvim-lspconfig",
	event = "VeryLazy",
	opts = {
		aggressive_mode = false,
		excluded_lsp_clients = { "vtsls", "rust_analyzer" },
		grace_period = 60 * 5, -- 5 minutes
		wakeup_delay = 5,
	},
})

-- Custom hover mapping with nice borders
vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover({
		border = {
			{ " ", "NormalFloat" },
			{ " ", "NormalFloat" },
			{ " ", "NormalFloat" },
			{ " ", "NormalFloat" },
			{ " ", "NormalFloat" },
			{ " ", "NormalFloat" },
			{ " ", "NormalFloat" },
			{ " ", "NormalFloat" },
		},
		max_width = 85,
		max_height = 25,
		focusable = false,
		close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
	})
end, { desc = "Hover Documentation" })

-- Format commands using Conform
vim.keymap.set("n", "<leader>f", "<cmd>Format<cr>", { desc = "Format buffer" })

-- Use a function for visual mode to handle range properly
vim.keymap.set("v", "<leader>f", function()
	-- Get visual selection marks
	local start_pos = vim.api.nvim_buf_get_mark(0, "<")
	local end_pos = vim.api.nvim_buf_get_mark(0, ">")

	-- Try Conform first, fall back to LSP if it fails
	local success = require("conform").format({
		range = {
			start = start_pos,
			["end"] = end_pos,
		},
		timeout_ms = 3000,
		quiet = true, -- Don't show errors
	})

	-- If Conform fails (likely due to partial selection), use LSP formatting
	if not success then
		vim.lsp.buf.format({
			range = {
				start = start_pos,
				["end"] = end_pos,
			},
			timeout_ms = 3000,
		})
	end
end, { desc = "Format selection" })

-- Create user commands for formatting
vim.api.nvim_create_user_command("Format", function()
	require("conform").format({
		lsp_fallback = true,
		timeout_ms = 3000,
	})
end, { desc = "Format current buffer" })

vim.api.nvim_create_user_command("FormatRange", function(opts)
	require("conform").format({
		lsp_fallback = true,
		range = {
			start = { opts.line1, 0 },
			["end"] = { opts.line2, 0 },
		},
		timeout_ms = 3000,
	})
end, {
	desc = "Format range (usage: :10,20FormatRange)",
	range = true,
})

return M
