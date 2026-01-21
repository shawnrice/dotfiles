vim.g.projects_dir = vim.env.HOME .. "/projects"

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local args = vim.fn.argv()
		if #args == 1 then
			local path = args[1]
			if vim.fn.isdirectory(path) == 1 then
				-- Change to absolute path of the directory
				vim.cmd("cd " .. vim.fn.fnamemodify(path, ":p"))
				-- -- Open nvim-tree to show the directory content
				-- Only open fzf if no session was restored
				vim.schedule(function()
					-- auto-session sets this variable when restoring
					if not vim.g.SessionLoad then
						if not vim.g.session_restoring and not vim.g.session_restored then
							require("fzf-lua").files()
						end
					end
				end)
				-- vim.cmd("NvimTreeOpen")
				-- Open Oil to browse the directory
				-- vim.cmd("Oil")
			end
		end
	end,
	desc = "Change to directory if opened with directory argument",
})

vim.api.nvim_create_autocmd("VimResized", {
	callback = function()
		vim.opt.scrolloff = math.floor(vim.api.nvim_win_get_height(0) / 2)
	end,
})

-- vim.api.nvim_create_autocmd("VimLeave", {
--   callback = function()
--     vim.cmd("SessionSave")
--   end,
-- })

-- vim.api.nvim_create_user_command("Reload", function()
-- 	-- Clear all loaded lua modules from your config
-- 	for name, _ in pairs(package.loaded) do
-- 		if name:match("^user") or name:match("^plugins") or name:match("^utils") or name:match("^workspace") then
-- 			package.loaded[name] = nil
-- 		end
-- 	end

-- 	-- Reload your modules (but NOT config.lazy which sets up lazy.nvim)
-- 	require("user.options")
-- 	require("user.keymaps")
-- 	require("user.vertical-help")
-- 	require("workspace")

-- 	-- Let lazy handle its own reloading
-- 	vim.cmd("Lazy reload")

-- 	vim.notify("󰑓 Config reloaded!", vim.log.levels.INFO)
-- end, {})

require("user.options")
require("config/lazy")
require("user.keymaps")
require("user.vertical-help")
require("workspace")

-- vim: ts=2 sts=2 sw=2 et
