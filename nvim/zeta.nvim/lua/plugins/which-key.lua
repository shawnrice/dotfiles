local M = {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")
		wk.setup({
			icons = {
				separator = "→",
				group = "+",
			},
			disable = { filetypes = { "dashboard", "alpha" } },
			win = {
				border = "rounded",
				padding = { 1, 3 },
			},
			triggers = { "<auto>" },
		})

		wk.add({
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>w", group = "Workspace" },
			{ "<leader>d", group = "Diagnostics" },
			{ "<leader>s", group = "Symbols" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>c", group = "Code" },
			{ "<leader>v", group = "View" },
			{ "<leader><leader>", group = "Session" },
		})
	end,
}

return M
