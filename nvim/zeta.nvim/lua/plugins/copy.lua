local M = {
	"YounesElhjouji/nvim-copy",
	lazy = true, -- ensures the plugin is loaded on startup
	config = function()
		require("nvim_copy").setup({
			ignore = {
				"*node_modules/*",
				"*__pycache__/*",
				"*.git/*",
				"*dist/*",
				"*build/*",
				"*.log",
			},
		})

		-- Optional key mappings:
		vim.api.nvim_set_keymap("n", "<leader>cb", ":CopyBuffersToClipboard<CR>", { noremap = true, silent = true })
	end,
}

return M
