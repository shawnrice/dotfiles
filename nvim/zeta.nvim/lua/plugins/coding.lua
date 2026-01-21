local M = {}

table.insert(M, {
	"nvim-mini/mini.pairs",
	event = "VeryLazy",
	opts = {
		modes = { insert = true, command = true, terminal = false },
		-- skip autopair when next character is one of these
		skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
		-- skip autopair when the cursor is inside these treesitter nodes
		skip_ts = { "string" },
		-- skip autopair when next character is closing pair
		-- and there are more closing pairs than opening pairs
		skip_unbalanced = true,
		-- better deal with markdown code blocks
		markdown = true,
	},
})

table.insert(M, {
	"nvim-mini/mini.surround",
	keys = {
		{ "gsa", desc = "Add Surrounding", mode = { "n", "v" } },
		{ "gsd", desc = "Delete Surrounding" },
		{ "gsf", desc = "Find Right Surrounding" },
		{ "gsF", desc = "Find Left Surrounding" },
		{ "gsh", desc = "Highlight Surrounding" },
		{ "gsr", desc = "Replace Surrounding" },
		{ "gsn", desc = "Update `MiniSurround.config.n_lines`" },
	},
	opts = {
		mappings = {
			add = "gsa", -- Add surrounding in Normal and Visual modes
			delete = "gsd", -- Delete surrounding
			find = "gsf", -- Find surrounding (to the right)
			find_left = "gsF", -- Find surrounding (to the left)
			highlight = "gsh", -- Highlight surrounding
			replace = "gsr", -- Replace surrounding
			update_n_lines = "gsn", -- Update `n_lines`
		},
	},
})

table.insert(M, {
	"nvim-mini/mini.ai",
	event = "VeryLazy",
	opts = function()
		local ai = require("mini.ai")
		return {
			n_lines = 500,
			custom_textobjects = {
				o = ai.gen_spec.treesitter({ -- code block
					a = { "@block.outer", "@conditional.outer", "@loop.outer" },
					i = { "@block.inner", "@conditional.inner", "@loop.inner" },
				}),
				f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
				c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
				t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
				d = { "%f[%d]%d+" }, -- digits
				e = { -- Word with case
					{ "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
					"^().*()$",
				},
				u = ai.gen_spec.function_call(), -- u for "Usage"
				U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
			},
		}
	end,
})

return M
