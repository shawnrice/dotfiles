local M = {}

local function strip_json_comments(str)
	local result = {}
	local in_string = false
	local i = 1

	while i <= #str do
		local c = str:sub(i, i)
		local next_c = str:sub(i + 1, i + 1)

		-- Toggle string state on unescaped quotes
		if c == '"' and (i == 1 or str:sub(i - 1, i - 1) ~= "\\") then
			in_string = not in_string
			table.insert(result, c)
			i = i + 1
		-- Skip single-line comments (outside strings)
		elseif not in_string and c == "/" and next_c == "/" then
			-- Skip until newline
			while i <= #str and str:sub(i, i) ~= "\n" do
				i = i + 1
			end
		-- Skip multi-line comments (outside strings)
		elseif not in_string and c == "/" and next_c == "*" then
			i = i + 2
			while i <= #str - 1 do
				if str:sub(i, i + 1) == "*/" then
					i = i + 2
					break
				end
				i = i + 1
			end
		else
			table.insert(result, c)
			i = i + 1
		end
	end

	local result_str = table.concat(result)

	-- Remove trailing commas
	result_str = result_str:gsub(",(%s*[%]}])", "%1")

	return result_str
end

---Finds and reads a .code-workspace file in the project
---@return table|nil
function M.read_workspace_file()
	local cwd = vim.fn.getcwd()

	-- Look for .code-workspace file
	local workspace_files = vim.fn.glob(cwd .. "/*.code-workspace", false, true)
	vim.notify("Found files: " .. vim.inspect(workspace_files), vim.log.levels.INFO)

	if #workspace_files == 0 then
		return nil
	end

	-- Read the first workspace file found
	local file = io.open(workspace_files[1], "r")
	if not file then
		return nil
	end

	local content = strip_json_comments(file:read("*all"))
	file:close()

	-- Parse JSON
	local ok, parsed = pcall(vim.json.decode, content)
	if not ok then
		vim.notify("Failed to parse .code-workspace file", vim.log.levels.WARN)
		vim.notify(content, vim.log.levels.WARN)
		return nil
	end

	return parsed
end

---Extract TypeScript settings from VSCode workspace
---@return table
function M.get_typescript_settings()
	local workspace = M.read_workspace_file()
	if not workspace or not workspace.settings then
		return {}
	end

	local vscode = workspace.settings
	local settings = {
		typescript = {
			tsserver = {},
			preferences = {},
			inlayHints = {},
		},
		javascript = {
			preferences = {},
			inlayHints = {},
		},
		vtsls = {},
	}

	-- Map VSCode settings to vtsls settings
	if vscode["typescript.tsserver.maxTsServerMemory"] then
		settings.typescript.tsserver.maxTsServerMemory = vscode["typescript.tsserver.maxTsServerMemory"]
	end

	if vscode["typescript.preferences.importModuleSpecifier"] then
		settings.typescript.preferences.importModuleSpecifier = vscode["typescript.preferences.importModuleSpecifier"]
	end

	if vscode["typescript.preferences.autoImportFileExcludePatterns"] then
		settings.typescript.preferences.autoImportFileExcludePatterns =
			vscode["typescript.preferences.autoImportFileExcludePatterns"]
	end

	if vscode["typescript.preferences.useAliasesForRenames"] ~= nil then
		settings.typescript.preferences.useAliasesForRenames = vscode["typescript.preferences.useAliasesForRenames"]
	end

	if vscode["javascript.preferences.useAliasesForRenames"] ~= nil then
		settings.javascript.preferences.useAliasesForRenames = vscode["javascript.preferences.useAliasesForRenames"]
	end

	-- Use workspace TypeScript if specified
	if vscode["typescript.tsdk"] then
		settings.vtsls.autoUseWorkspaceTsdk = true
	end

	return settings
end

---Get ESLint settings from VSCode workspace
---@return table
function M.get_eslint_settings()
	local workspace = M.read_workspace_file()
	if not workspace or not workspace.settings then
		return {}
	end

	local vscode = workspace.settings
	local settings = {}

	if vscode["eslint.useFlatConfig"] ~= nil then
		settings.useFlatConfig = vscode["eslint.useFlatConfig"]
	end

	if vscode["eslint.validate"] then
		settings.validate = vscode["eslint.validate"]
	end

	return settings
end

return M
