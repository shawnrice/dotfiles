-- plugins/lsp/python.lua
return {
  mason = { "pyright", "black", "ruff" },
  treesitter = { "python" },
  formatters = {
    python = { "black" },
  },

  servers = {
    pyright = {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            diagnosticMode = "workspace",
            useLibraryCodeForTypes = true,
            autoImportCompletions = true,
          },
          inlayHints = {
            variableTypes = true,
            functionReturnTypes = true,
            parameterTypes = true,
          },
        },
      },
    },
  },
}
