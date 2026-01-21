-- lua/workspace.lua
local M = {}

-- Store current workspace globally
vim.g.current_workspace = nil

function M.clean_jsonc_content(content)
  local lines = vim.split(content, '\n')
  local cleaned_lines = {}

  for _, line in ipairs(lines) do
    -- Remove single-line comments (//.*)
    local cleaned = line:gsub('%s*//.*$', '')

    -- Skip empty lines after comment removal
    if cleaned:match '%S' then
      table.insert(cleaned_lines, cleaned)
    end
  end

  -- Join back and handle trailing commas more carefully
  local joined = table.concat(cleaned_lines, '\n')

  -- Remove trailing commas before } or ] (with possible whitespace)
  joined = joined:gsub(',%s*\n%s*}', '\n}')
  joined = joined:gsub(',%s*\n%s*]', '\n]')
  joined = joined:gsub(',%s*}', '}')
  joined = joined:gsub(',%s*]', ']')

  return joined
end

function M.find_workspace_file()
  local cwd = vim.fn.getcwd()
  local current_dir = cwd

  -- Search upward through parent directories
  while current_dir ~= '/' and current_dir ~= '' do
    local workspace_files = vim.fn.glob(current_dir .. '/*.code-workspace', false, true)

    if #workspace_files > 0 then
      -- Found workspace file(s), return the first one
      return workspace_files[1]
    end

    -- Move to parent directory
    current_dir = vim.fn.fnamemodify(current_dir, ':h')
  end

  return nil
end

function M.parse_vscode_workspace(workspace_path)
  workspace_path = workspace_path or M.find_workspace_file()

  if not workspace_path then
    return nil
  end

  if vim.fn.filereadable(workspace_path) == 0 then
    vim.notify('Workspace file not readable: ' .. workspace_path, vim.log.levels.ERROR)
    return nil
  end

  local content = table.concat(vim.fn.readfile(workspace_path), '\n')
  local cleaned_content = M.clean_jsonc_content(content)

  local ok, workspace = pcall(vim.json.decode, cleaned_content)

  if not ok then
    vim.notify('Failed to parse workspace file: ' .. workspace, vim.log.levels.ERROR)
    return nil
  end

  -- Convert relative paths to absolute
  local root_dir = vim.fn.fnamemodify(workspace_path, ':h')
  local folders = {}

  for _, folder in ipairs(workspace.folders or {}) do
    local path = folder.path == '.' and root_dir or (root_dir .. '/' .. folder.path)
    table.insert(folders, {
      name = folder.name or folder.path,
      path = vim.fn.resolve(path),
    })
  end

  return {
    folders = folders,
    settings = workspace.settings or {},
    tasks = workspace.tasks or {},
    extensions = workspace.extensions or {},
    root_dir = root_dir,
    workspace_file = workspace_path,
  }
end

function M.get_typescript_config(workspace)
  if not workspace or not workspace.settings then
    return {}
  end

  local ts_settings = {}
  local settings = workspace.settings

  -- Extract TypeScript SDK path
  if settings['typescript.tsdk'] then
    ts_settings.tsdk = workspace.root_dir .. '/' .. settings['typescript.tsdk']
  end

  -- Extract preferences
  if settings['typescript.preferences.importModuleSpecifier'] then
    ts_settings.importModuleSpecifier = settings['typescript.preferences.importModuleSpecifier']
  end

  if settings['typescript.preferences.autoImportFileExcludePatterns'] then
    ts_settings.autoImportFileExcludePatterns = settings['typescript.preferences.autoImportFileExcludePatterns']
  end

  -- Memory settings
  if settings['typescript.tsserver.maxTsServerMemory'] then
    ts_settings.maxTsServerMemory = settings['typescript.tsserver.maxTsServerMemory']
  end

  -- Inlay hints
  if settings['typescript.inlayHints.parameterNames.enabled'] then
    ts_settings.inlayHintsParameterNames = settings['typescript.inlayHints.parameterNames.enabled']
  end

  return ts_settings
end

function M.get_eslint_config(workspace)
  if not workspace or not workspace.settings then
    return {}
  end

  local eslint_settings = {}
  local settings = workspace.settings

  if settings['eslint.useFlatConfig'] then
    eslint_settings.useFlatConfig = settings['eslint.useFlatConfig']
  end

  if settings['eslint.validate'] then
    eslint_settings.validate = settings['eslint.validate']
  end

  return eslint_settings
end

function M.create_workspace_root_dir()
  local workspace = vim.g.current_workspace
  if not workspace then
    return require('lspconfig.util').root_pattern('package.json', 'tsconfig.json', '.git')
  end

  return function(fname)
    -- Check if file is in any workspace folder
    for _, folder in ipairs(workspace.folders) do
      if vim.startswith(fname, folder.path) then
        return workspace.root_dir
      end
    end

    -- Fallback to standard detection
    return require('lspconfig.util').root_pattern('package.json', 'tsconfig.json', '.git')(fname)
  end
end

function M.setup_workspace_lsps(workspace)
  local ts_config = M.get_typescript_config(workspace)
  local eslint_config = M.get_eslint_config(workspace)

  -- Store workspace config globally so LSPs can access it
  vim.g.workspace_typescript_config = ts_config
  vim.g.workspace_eslint_config = eslint_config
  vim.g.workspace_root_dir_func = M.create_workspace_root_dir()

  -- Only restart LSPs if they're already running
  -- If called during startup (VimEnter), LSPs haven't started yet
  -- and will automatically pick up the globals when they do start
  local clients = vim.lsp.get_clients()
  if #clients > 0 then
    vim.cmd 'LspRestart'
    vim.notify('LSPs restarted with workspace configuration', vim.log.levels.INFO)
  end
end

function M.setup_from_file(workspace_file)
  local workspace = M.parse_vscode_workspace(workspace_file)
  if not workspace then
    vim.notify('Failed to load workspace', vim.log.levels.ERROR)
    return false
  end

  -- Store workspace info globally
  vim.g.current_workspace = workspace

  -- Setup LSPs with workspace config
  M.setup_workspace_lsps(workspace)

  -- Change working directory to workspace root
  vim.cmd('cd ' .. vim.fn.fnameescape(workspace.root_dir))

  vim.notify(
    '📁 ' .. vim.fn.fnamemodify(workspace.workspace_file, ':t:r') .. ' (' .. #workspace.folders .. ' folders)',
    vim.log.levels.INFO
  )

  return true
end

function M.get_current_workspace()
  return vim.g.current_workspace
end

function M.is_workspace_loaded()
  return vim.g.current_workspace ~= nil
end

function M.get_workspace_folders()
  local workspace = vim.g.current_workspace
  if not workspace then
    return {}
  end

  return workspace.folders
end

function M.print_workspace_info()
  local workspace = vim.g.current_workspace
  if not workspace then
    print 'No workspace loaded'
    return
  end

  print('Current workspace: ' .. workspace.root_dir)
  print('Workspace file: ' .. workspace.workspace_file)
  print 'Folders:'
  for _, folder in ipairs(workspace.folders) do
    print('  - ' .. folder.name .. ' (' .. folder.path .. ')')
  end
end

-- Auto-detect workspace on startup
function M.auto_load_workspace()
  local workspace_file = M.find_workspace_file()
  if workspace_file then
    -- Automatically load workspace without prompting
    M.setup_from_file(workspace_file)
  end
end

-- Create user commands
vim.api.nvim_create_user_command('LoadWorkspace', function(opts)
  if opts.args == '' then
    -- No args, look for workspace files in current dir
    local workspace_file = M.find_workspace_file()
    if workspace_file then
      M.setup_from_file(workspace_file)
    else
      vim.notify('No workspace file found in current directory', vim.log.levels.WARN)
    end
  else
    -- Specific workspace file provided
    M.setup_from_file(opts.args)
  end
end, {
  nargs = '?',
  complete = 'file',
  desc = 'Load VS Code workspace file',
})

vim.api.nvim_create_user_command('WorkspaceInfo', function()
  M.print_workspace_info()
end, { desc = 'Show current workspace information' })

vim.api.nvim_create_user_command('UnloadWorkspace', function()
  vim.g.current_workspace = nil
  vim.notify('Workspace unloaded', vim.log.levels.INFO)
end, { desc = 'Unload current workspace' })

-- Auto-load workspace on VimEnter
vim.api.nvim_create_autocmd('VimEnter', {
  callback = M.auto_load_workspace,
  desc = 'Auto-detect and load workspace on startup',
})

return M
