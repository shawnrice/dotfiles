local M = {
	"ibhagwan/fzf-lua",
	dependencies = { { "nvim-mini/mini.icons", version = "*" } },
	opts = {
		winopts = {
			border = "rounded",
		},
		keymap = {
			builtin = {
				["<C-f>"] = "toggle-fullscreen",
				["<C-r>"] = "toggle-preview",
				["<C-j>"] = "down",
				["<C-k>"] = "up",
			},
		},
		oldfiles = {
			include_current_session = true,
			cwd_only = true, -- we might want to not have this depending on how it works
			stat_file = true, -- verify files exist on disk
		},
		previewers = {
			syntax_limit_b = 1024 * 100, -- 100KB
		},
	},
	config = function(_, opts)
		require("fzf-lua").setup(opts)

		-- Add a command to show messages in a searchable buffer
		vim.api.nvim_create_user_command("Messages", function()
			-- Create a new buffer
			local buf = vim.api.nvim_create_buf(false, true)
			local win = vim.api.nvim_open_win(buf, true, {
				relative = "editor",
				width = math.floor(vim.o.columns * 0.8),
				height = math.floor(vim.o.lines * 0.8),
				row = math.floor(vim.o.lines * 0.1),
				col = math.floor(vim.o.columns * 0.1),
				style = "minimal",
				border = "rounded",
			})

			-- Get messages and reverse them to show newest first
			local messages = vim.split(vim.fn.execute("messages"), "\n")
			table.remove(messages, 1) -- Remove the "Messages maintainer: ..." line
			table.remove(messages, 1) -- Remove the "--- Messages ---" line
			table.remove(messages, #messages) -- Remove the last empty line

			-- Set buffer options
			vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
			vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
			vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
			vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
			vim.api.nvim_set_option_value("buflisted", false, { buf = buf })
			vim.api.nvim_set_option_value("filetype", "messages", { buf = buf })

			-- Add messages to buffer
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, messages)

			-- Set window options
			vim.api.nvim_set_option_value("wrap", false, { win = win })
			vim.api.nvim_set_option_value("number", true, { win = win })
			vim.api.nvim_set_option_value("relativenumber", false, { win = win })
			vim.api.nvim_set_option_value("cursorline", true, { win = win })

			-- Add keymaps
			local function map(mode, lhs, rhs, opts)
				vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { buffer = buf }, opts or {}))
			end

			map("n", "q", function()
				vim.api.nvim_win_close(win, true)
			end, { desc = "Close messages window" })
			map("n", "<Esc>", function()
				vim.api.nvim_win_close(win, true)
			end, { desc = "Close messages window" })
			map("n", "/", "/", { desc = "Search in messages" })
		end, {})

		-- Essential keymaps

		vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { noremap = true, desc = "[F]ind [f]iles" })
		vim.keymap.set(
			"n",
			"<leader>fr",
			"<cmd>FzfLua oldfiles<cr>",
			{ noremap = true, desc = "[F]ind [r]ecent files" }
		)
		vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { noremap = true, desc = "[F]ind [g]rep" })
		vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { noremap = true, desc = "[F]ind [b]uffers" })
		vim.keymap.set(
			"n",
			"<leader>fl",
			"<cmd>FzfLua blines<cr>",
			{ noremap = true, desc = "[F]ind [l]ines in buffer" }
		)
		vim.keymap.set(
			"n",
			"<leader>fL",
			"<cmd>FzfLua lines<cr>",
			{ noremap = true, desc = "[F]ind [L]ines in all buffers" }
		)
		vim.keymap.set(
			"n",
			"<leader>f/",
			"<cmd>FzfLua grep_curbuf<cr>",
			{ noremap = true, desc = "[F]ind [/] grep in current buffer" }
		)
		-- vim.keymap.set('n', 'gr', '<cmd>FzfLua lsp_references<cr>', { noremap = true, desc = "[G]oto [r]eferences"})
		vim.keymap.set(
			"n",
			"<leader>ds",
			"<cmd>FzfLua lsp_document_symbols<cr>",
			{ noremap = true, desc = "[D]ocument [S]ymbols" }
		)
		vim.keymap.set(
			"n",
			"<leader>ca",
			"<cmd>FzfLua lsp_code_actions<cr>",
			{ noremap = true, desc = "[C]ode [A]ctions" }
		)
		vim.keymap.set(
			"n",
			"<leader>fd",
			"<cmd>FzfLua diagnostics_document<cr>",
			{ noremap = true, desc = "[F]ind [D]iagnostics" }
		)
		vim.keymap.set(
			"n",
			"<leader>fws",
			"<cmd>FzfLua lsp_workspace_symbols<cr>",
			{ noremap = true, desc = "[F]ind [W]orkspace [S]ymbols" }
		)

		vim.keymap.set("n", "<leader>fw", function()
			if vim.g.current_workspace then
				local folders = vim.tbl_map(function(f)
					return f.path
				end, vim.g.current_workspace.folders)
				require("fzf-lua").files({ cwd = folders[1] })
			else
				require("fzf-lua").files()
			end
		end, { desc = "[F]ind [W]orkspace files" })

		vim.keymap.set(
			"n",
			"<leader>fG",
			"<cmd>FzfLua grep_cword<cr>",
			{ noremap = true, desc = "[F]ind [G]rep word under cursor" }
		)
		vim.keymap.set(
			"v",
			"<leader>fG",
			"<cmd>FzfLua grep_visual<cr>",
			{ noremap = true, desc = "[F]ind [G]rep visual selection" }
		)
		vim.keymap.set(
			"n",
			"<leader>fR",
			"<cmd>FzfLua resume<cr>",
			{ noremap = true, desc = "[F]ind [R]esume" }
		)
		vim.keymap.set("n", "<leader>gf", "<cmd>FzfLua git_files<cr>", { noremap = true, desc = "[G]it [F]iles" })
	end,
}

return M
