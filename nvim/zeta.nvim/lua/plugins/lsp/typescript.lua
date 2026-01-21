-- plugins/lsp/typescript.lua
-- Default TypeScript/JavaScript LSP settings
-- These will be automatically enhanced with .code-workspace settings via workspace.lua
-- when a workspace file is detected and loaded

local default_ts_settings = {
	typescript = {
		tsserver = {
			maxTsServerMemory = 16384,
		},
		preferences = {
			importModuleSpecifier = "project-relative",
		},
		inlayHints = {
			includeInlayParameterNameHints = "all",
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		},
	},
	javascript = {
		inlayHints = {
			includeInlayParameterNameHints = "all",
		},
	},
	vtsls = {
		autoUseWorkspaceTsdk = true,
	},
}

return {
	mason = { "vtsls", "eslint", "prettierd" },
	treesitter = { "typescript", "javascript", "tsx" }, -- Removed "jsx" - it's handled by "javascript"
	formatters = {
		typescript = { "prettierd" },
		javascript = { "prettierd" },
		typescriptreact = { "prettierd" },
		javascriptreact = { "prettierd" },
	},

	servers = {
		vtsls = {
			settings = default_ts_settings,
			on_attach = function(client, bufnr)
				-- Add workspace folders if available
				if vim.g.current_workspace then
					local existing_folders = vim.lsp.buf.list_workspace_folders()
					for _, folder in ipairs(vim.g.current_workspace.folders) do
						if not vim.tbl_contains(existing_folders, folder.path) then
							vim.lsp.buf.add_workspace_folder(folder.path)
						end
					end
				end
			end,
		},
		eslint = {
			-- ESLint config will be enhanced by workspace settings via workspace.lua
			settings = { format = false },
		},
	},
}
