local M = {}

-- @see https://github.com/stevearc/overseer.nvim
table.insert(M, {
	"stevearc/overseer.nvim",
	opts = {},
})

-- Debugger
-- Need to set this up
-- @see https://github.com/rcarriga/nvim-dap-ui
table.insert(M, {
	"rcarriga/nvim-dap-ui",
	dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
})

local function check_for_updates()
	local ok, lazy_status = pcall(require, "lazy.status")
	if not ok then
		return ""
	end
	return lazy_status.updates()
end

local function has_updates()
	local ok, lazy_status = pcall(require, "lazy.status")
	if not ok then
		return ""
	end
	return lazy_status.has_updates()
end

local lazy_updates = {
	check_for_updates,
	cond = has_updates,
	color = { fg = "#ff9e64" },
	on_click = function()
		vim.cmd("Lazy")
	end,
}

local function format_current_line_blame(name, blame_info, opts)
	if blame_info.author == name then
		blame_info.author = "You"
	end

	local date = os.date("%Y-%m-%d", tonumber(blame_info.author_time))
	local summary = blame_info.summary
	local text = string.format("%s, %s — %s", blame_info.author, date, summary)

	return { { " " .. text, "GitSignsCurrentLineBlame" } }
end

-- A cache of the last blame that we got. The cache should help with flickering
local last_blame = ""

local function get_git_blame()
	-- Get the raw blame dictionary from gitsigns
	local ok, blame_dict = pcall(vim.api.nvim_buf_get_var, 0, "gitsigns_blame_line_dict")
	if not ok or not blame_dict then
		-- Return last value or loading indicator
		return last_blame ~= "" and last_blame or "  Loading..."
	end

	local author = blame_dict.author
	local date = os.date("%Y-%m-%d", tonumber(blame_dict.author_time))

	-- Keep emojis in lualine
	last_blame = string.format("%s %s: %s", author, date, blame_dict.summary)
	return last_blame
end

local git_blame = {
	get_git_blame,
	icon = "",
}

-- @see https://github.com/nvim-lualine/lualine.nvim
-- LuaLine should go elsewhere....
table.insert(M, {
	"nvim-lualine/lualine.nvim",
	opts = {
		options = {
			icons_enabled = true,
			theme = "auto",
			-- component_separators = { left = "", right = "" },
			component_separators = { left = "|", right = "|" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = {
				statusline = {},
				winbar = {},
			},
			ignore_focus = {},
			always_divide_middle = true,
			always_show_tabline = true,
			globalstatus = false,
			refresh = {
				statusline = 1000,
				tabline = 1000,
				winbar = 1000,
				refresh_time = 16, -- ~60fps
				events = {
					"WinEnter",
					"BufEnter",
					"BufWritePost",
					"SessionLoadPost",
					"FileChangedShellPost",
					"VimResized",
					"Filetype",
					"CursorMoved",
					"CursorMovedI",
					"ModeChanged",
				},
			},
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { "filename", git_blame },
			lualine_x = { "selectioncount", lazy_updates },
			lualine_y = { "filetype", "lsp_status" },
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {},
	},
})

return M
