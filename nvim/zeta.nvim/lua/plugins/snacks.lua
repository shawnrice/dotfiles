return {
	{
		"folke/noice.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			messages = {
				enabled = false, -- Disable message handling
			},
			notify = {
				enabled = false, -- Disable notification handling
			},
			lsp = {
				progress = {
					enabled = false, -- Disable LSP progress
				},
			},
			cmdline = {
				enabled = true, -- Only enable cmdline
				view = "cmdline_popup", -- Use popup view
			},
			routes = {
				-- Route everything else to default views
				{
					view = "messages",
					filter = { event = "msg_show" },
				},
			},
			views = {
				cmdline_popup = {
					size = {
						width = "60%", -- or fixed width like 80
						height = "auto", -- or fixed height like 3
					},
					position = {
						row = "25%", -- center vertically
						col = "50%", -- center horizontally
					},
				},
			},
		},
	},
	{
		"folke/snacks.nvim",
		opts = {
			dashboard = {
				-- your dashboard configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			},
			input = {
				enabled = true,
				icon = "󰘳 ",
				icon_hl = "SnacksInputIcon",
				icon_pos = "left",
				prompt_pos = "title",
				expand = true,
			},
			styles = {
				input = {
					relative = "editor",
					position = "float",
					border = "rounded",
					title_pos = "center",
					height = 1,
					width = 0.4, -- Use relative width (40% of screen)
					row = 0.4, -- Position at 40% down from top
					col = 0.5, -- Center horizontally
					backdrop = false,
					wo = {
						winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
						cursorline = false,
					},
					bo = {
						filetype = "snacks_input",
					},
				},
			},
		},
	},
}
