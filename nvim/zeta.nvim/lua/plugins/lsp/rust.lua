-- plugins/lsp/rust.lua
return {
  mason = { "rust_analyzer", "rustfmt" },
  treesitter = { "rust" },
  formatters = {
    rust = { "rustfmt" },
  },

  servers = {
    rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
          },
          checkOnSave = {
            command = "clippy",
            extraArgs = { "--no-deps" },
          },
          procMacro = {
            enable = true,
          },
          inlayHints = {
            lifetimeElisionHints = { enable = "skip_trivial" },
            reborrowHints = { enable = "mutable" },
            renderColons = true,
            typeHints = { enable = true },
            parameterHints = { enable = true },
          },
        },
      },
    },
  },
}
