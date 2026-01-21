-- lua/utils/language-configs.lua
local M = {}

-- Cache the collected configs so we don't re-scan on every call
local cached_configs = nil

function M.collect_language_configs()
  if cached_configs then
    return cached_configs
  end

  local lsp_dir = vim.fn.stdpath('config') .. '/lua/plugins/lsp'

  -- Check if directory exists
  if vim.fn.isdirectory(lsp_dir) == 0 then
    cached_configs = {
      mason = {},
      treesitter = {},
      formatters = {},
      servers = {},
    }
    return cached_configs
  end

  local language_files = vim.fn.glob(lsp_dir .. '/*.lua', false, true)

  local all_mason = {}
  local all_treesitter = {}
  local all_formatters = {}
  local all_servers = {}

  for _, file_path in ipairs(language_files) do
    local lang_name = vim.fn.fnamemodify(file_path, ':t:r')

    -- Skip if it's not a valid language config file
    if lang_name:match('^[a-zA-Z0-9_-]+$') then
      local ok, config = pcall(require, "plugins.lsp." .. lang_name)

      if ok and type(config) == 'table' then
        -- Collect Mason LSPs
        if config.mason then
          vim.list_extend(all_mason, config.mason)
        end

        -- Collect Treesitter parsers
        if config.treesitter then
          vim.list_extend(all_treesitter, config.treesitter)
        end

        -- Collect formatters
        if config.formatters then
          for ft, formatters in pairs(config.formatters) do
            all_formatters[ft] = formatters
          end
        end

        -- Collect server configs
        if config.servers then
          for server_name, server_config in pairs(config.servers) do
            all_servers[server_name] = server_config
          end
        end

        -- vim.notify("Loaded language config: " .. lang_name, vim.log.levels.DEBUG)
      else
        vim.notify("Failed to load language config: " .. lang_name, vim.log.levels.WARN)
      end
    end
  end

  cached_configs = {
    mason = all_mason,
    treesitter = all_treesitter,
    formatters = all_formatters,
    servers = all_servers,
  }

  return cached_configs
end

-- Function to clear cache (useful for development/reloading configs)
function M.clear_cache()
  cached_configs = nil
end

-- Get just the mason requirements
function M.get_mason_packages()
  return M.collect_language_configs().mason
end

function M.get_mason_lsp_servers()
  local servers = M.collect_language_configs().servers
  return vim.tbl_keys(servers)
end

function M.get_mason_tools()
  local all_mason = M.get_mason_packages()
  local lsp_servers = M.get_mason_lsp_servers()

  return vim.tbl_filter(function(item)
    return not vim.tbl_contains(lsp_servers, item)
  end, all_mason)
end

-- Get just the treesitter parsers
function M.get_treesitter_parsers()
  return M.collect_language_configs().treesitter
end

-- Get just the formatters
function M.get_formatters()
  return M.collect_language_configs().formatters
end

-- Get just the server configs
function M.get_server_configs()
  return M.collect_language_configs().servers
end

-- Create a user command to reload language configs
vim.api.nvim_create_user_command('ReloadLanguageConfigs', function()
  M.clear_cache()
  local configs = M.collect_language_configs()
  vim.notify("Reloaded " .. #configs.mason .. " mason packages, " ..
            #configs.treesitter .. " treesitter parsers, " ..
            vim.tbl_count(configs.formatters) .. " formatter configs, " ..
            vim.tbl_count(configs.servers) .. " server configs",
            vim.log.levels.INFO)
end, { desc = 'Reload language configurations' })

return M
