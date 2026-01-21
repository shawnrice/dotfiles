local M = {}

-- @see https://codecompanion.olimorris.dev/
-- @see https://github.com/olimorris/codecompanion.nvim
table.insert(M, {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		-- NOTE: The log_level is in `opts.opts`
		opts = {
			-- log_level = "DEBUG", -- or "TRACE"
		},
	},
})

-- @see https://github.com/yetone/avante.nvim

return M
