local M = {
	"folke/which-key.nvim",
	lazy = true,
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = true })
			end,
			desc = "Buffer local key maps",
		},
	},
}

return M
