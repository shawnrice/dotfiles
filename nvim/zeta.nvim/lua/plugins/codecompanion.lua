return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle CodeCompanion Chat" },
    { "<leader>cA", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
    { "<leader>cq", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "CodeCompanion Quick" },
    {
      "<leader>cm",
      function()
        local models = {
          -- OpenRouter models
          { adapter = "openrouter", model = "anthropic/claude-sonnet-4", label = "Claude Sonnet 4 (OpenRouter)" },
          { adapter = "openrouter", model = "anthropic/claude-opus-4", label = "Claude Opus 4 (OpenRouter)" },
          { adapter = "openrouter", model = "anthropic/claude-haiku-3.5", label = "Claude Haiku 3.5 (OpenRouter)" },
          { adapter = "openrouter", model = "openai/gpt-4o", label = "GPT-4o (OpenRouter)" },
          { adapter = "openrouter", model = "google/gemini-2.0-flash-001", label = "Gemini 2.0 Flash (OpenRouter)" },
          -- Ollama models
          { adapter = "ollama", model = "llama3.2:latest", label = "Llama 3.2 (Ollama)" },
          { adapter = "ollama", model = "codellama:13b", label = "CodeLlama 13B (Ollama)" },
          { adapter = "ollama", model = "mistral:latest", label = "Mistral (Ollama)" },
          { adapter = "ollama", model = "deepseek-coder:6.7b", label = "DeepSeek Coder (Ollama)" },
        }

        local labels = vim.tbl_map(function(m) return m.label end, models)

        vim.ui.select(labels, { prompt = "Select model:" }, function(choice, idx)
          if choice and idx then
            local selected = models[idx]
            vim.g.codecompanion_adapter = selected.adapter
            vim.g.codecompanion_model = selected.model
            vim.notify("CodeCompanion: " .. choice, vim.log.levels.INFO)
          end
        end)
      end,
      desc = "Select CodeCompanion Model",
    },
  },
  opts = function()
    -- Helper to read file contents
    local function read_file(path)
      local f = io.open(path, "r")
      if not f then return nil end
      local content = f:read("*a")
      f:close()
      return content
    end

    -- Helper to find files matching pattern
    local function find_files(pattern)
      return vim.fn.globpath(vim.fn.getcwd(), pattern, false, true)
    end

    -- Build OpenSpec system prompt addition
    local function get_openspec_prompt()
      local agents_md = read_file(vim.fn.getcwd() .. "/openspec/AGENTS.md")
      if agents_md then
        return [[

## OpenSpec Integration

This project uses OpenSpec for spec-driven development. Key principles:
- Always check openspec/AGENTS.md for project-specific AI instructions
- For planning, proposals, or significant changes, follow the OpenSpec workflow
- Specs live in openspec/specs/, changes in openspec/changes/
- Use /spec to view specifications, /change to view change proposals

]] .. "Current AGENTS.md:\n```\n" .. agents_md .. "\n```\n"
      end
      return ""
    end

    return {
      adapters = {
        openrouter = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://openrouter.ai/api",
              api_key = "OPENROUTER_API_KEY",
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = {
                default = function()
                  return vim.g.codecompanion_model or "anthropic/claude-sonnet-4"
                end,
              },
            },
          })
        end,
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = function()
                  return vim.g.codecompanion_model or "llama3.2:latest"
                end,
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = function()
            return vim.g.codecompanion_adapter or "openrouter"
          end,
          system_prompt = function()
            local base = [[You are a helpful AI coding assistant. Be concise and precise.]]
            return base .. get_openspec_prompt()
          end,
        },
        inline = {
          adapter = function()
            return vim.g.codecompanion_adapter or "openrouter"
          end,
        },
      },
      slash_commands = {
        ["spec"] = {
          description = "Include OpenSpec specification files",
          callback = function(chat)
            local specs = find_files("openspec/specs/**/*.md")
            if #specs == 0 then
              vim.notify("No OpenSpec specs found in openspec/specs/", vim.log.levels.WARN)
              return
            end

            -- Add "All specs" option
            table.insert(specs, 1, "__ALL__")
            local display = vim.tbl_map(function(s)
              if s == "__ALL__" then return "[All Specs]" end
              return s:gsub(vim.fn.getcwd() .. "/", "")
            end, specs)

            vim.ui.select(display, { prompt = "Select spec:" }, function(_, idx)
              if not idx then return end

              if specs[idx] == "__ALL__" then
                -- Include all specs
                for i = 2, #specs do
                  local content = read_file(specs[i])
                  if content then
                    local rel_path = specs[i]:gsub(vim.fn.getcwd() .. "/", "")
                    chat:add_reference({ content = content, source = rel_path })
                  end
                end
                vim.notify("Added all specs to context", vim.log.levels.INFO)
              else
                local content = read_file(specs[idx])
                if content then
                  local rel_path = specs[idx]:gsub(vim.fn.getcwd() .. "/", "")
                  chat:add_reference({ content = content, source = rel_path })
                  vim.notify("Added " .. rel_path .. " to context", vim.log.levels.INFO)
                end
              end
            end)
          end,
        },
        ["change"] = {
          description = "Include OpenSpec change proposals",
          callback = function(chat)
            local changes_dir = vim.fn.getcwd() .. "/openspec/changes"
            local changes = vim.fn.globpath(changes_dir, "*", false, true)

            -- Filter to directories only
            changes = vim.tbl_filter(function(p)
              return vim.fn.isdirectory(p) == 1
            end, changes)

            if #changes == 0 then
              vim.notify("No OpenSpec changes found in openspec/changes/", vim.log.levels.WARN)
              return
            end

            local display = vim.tbl_map(function(c)
              return vim.fn.fnamemodify(c, ":t")
            end, changes)

            vim.ui.select(display, { prompt = "Select change:" }, function(choice, idx)
              if not choice or not idx then return end

              local change_dir = changes[idx]
              local files = { "proposal.md", "tasks.md", "design.md" }

              for _, file in ipairs(files) do
                local path = change_dir .. "/" .. file
                local content = read_file(path)
                if content then
                  local rel_path = path:gsub(vim.fn.getcwd() .. "/", "")
                  chat:add_reference({ content = content, source = rel_path })
                end
              end

              -- Also include any spec deltas
              local spec_deltas = vim.fn.globpath(change_dir .. "/specs", "**/*.md", false, true)
              for _, spec in ipairs(spec_deltas) do
                local content = read_file(spec)
                if content then
                  local rel_path = spec:gsub(vim.fn.getcwd() .. "/", "")
                  chat:add_reference({ content = content, source = rel_path })
                end
              end

              vim.notify("Added change '" .. choice .. "' to context", vim.log.levels.INFO)
            end)
          end,
        },
        ["proposal"] = {
          description = "Start a new OpenSpec proposal",
          callback = function(chat)
            vim.ui.input({ prompt = "Change ID (e.g., add-auth-feature):" }, function(change_id)
              if not change_id or change_id == "" then return end

              local prompt = string.format([[
I want to create a new OpenSpec change proposal with ID: %s

Please help me draft:
1. A proposal.md with the rationale for this change
2. Initial tasks.md with implementation checklist
3. Any spec deltas needed

First, ask me clarifying questions about what I'm trying to accomplish.
]], change_id)

              chat:add_message({ role = "user", content = prompt })
            end)
          end,
        },
      },
      display = {
        chat = {
          window = {
            layout = "vertical",
            width = 0.3,
          },
        },
      },
    }
  end,
}
