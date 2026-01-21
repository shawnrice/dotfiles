return {
  mason = { "lua_ls", "stylua" },
  treesitter = { "lua" },
  formatters = {
    lua = { "stylua" },
  },

  servers = {
    lua_ls = {
      settings = {
        Lua = {
          completion = { callSnippet = "Replace" },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
            -- Alternative approach that works better with newer Lua LS:
            -- library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    },
  },
}
