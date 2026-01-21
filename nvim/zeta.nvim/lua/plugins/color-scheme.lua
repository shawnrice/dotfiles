local M = {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = true,
	opts = {},
}

M.config = function()
	vim.cmd("colorscheme gruvbox")
end

return M
