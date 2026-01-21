-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	ui = {
		border = "rounded",
	},
	custom_keys = {
		-- You can define custom key maps here. If present, the description will
		-- be shown in the help menu.
		-- To disable one of the defaults, set it to false.

		["<localleader>l"] = {
			function(plugin)
				require("lazy.util").float_term({ "lazygit", "log" }, {
					cwd = plugin.dir,
				})
			end,
			desc = "Open lazygit log",
		},

		["<localleader>i"] = {
			function(plugin)
				Util.notify(vim.inspect(plugin), {
					title = "Inspect " .. plugin.name,
					lang = "lua",
				})
			end,
			desc = "Inspect Plugin",
		},

		["<localleader>t"] = {
			function(plugin)
				require("lazy.util").float_term(nil, {
					cwd = plugin.dir,
				})
			end,
			desc = "Open terminal in plugin dir",
		},
	},
	dev = { path = vim.g.projects_dir },
	diff = { cmd = "diffview.nvim" },

	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = {
		missing = false, -- Do not automatically install on startup.
		colorscheme = { "gruvbox" },
	},
	-- automatically check for plugin updates
	checker = { enabled = true, notify = false },
	change_detection = { notify = true },
	rocks = { enabled = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				"netrwPlugin",
				"rplugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
