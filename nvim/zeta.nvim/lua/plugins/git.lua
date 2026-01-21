local M = {}

-- @see https://github.com/sindrets/diffview.nvim
table.insert(M, {
	"sindrets/diffview.nvim",
})

---Removes emoji from a string
---@param x string
local function strip_emoji(x)
	return x
		:gsub("[\u{1F300}-\u{1F9FF}]", "") -- Emoji ranges
		:gsub("[\u{2600}-\u{26FF}]", "") -- Misc symbols
		:gsub("[\u{2700}-\u{27BF}]", "") -- Dingbats
		:gsub("^%s+", "") -- Trim leading spaces
end

local function format_current_line_blame(name, blame_info, opts)
	if blame_info.author == name then
		blame_info.author = "You"
	end

	local date = os.date("%Y-%m-%d", tonumber(blame_info.author_time))
	local summary = strip_emoji(blame_info.summary)
	local text = string.format("%s, %s — %s", blame_info.author, date, summary)

	return { { " " .. text, "GitSignsCurrentLineBlame" } }
end

table.insert(M, {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function(_, opts)
		require("gitsigns").setup(opts)
		vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })
	end,
	opts = {
		signs = {
			add = { text = "│" },
			change = { text = "│" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		current_line_blame = true, -- Toggle with :Gitsigns toggle_current_line_blame
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
			delay = 500, -- Delay in ms before showing blame
		},
		current_line_blame_formatter = format_current_line_blame,
	},
})

return M
