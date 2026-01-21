-- plugins/lsp/zig.lua
return {
  mason = { "zls" },
  treesitter = { "zig" },
  formatters = {
    zig = { "zigfmt" },
  },

  servers = {
    zls = {
      settings = {
        zig = {
          enableInlayHints = true,
          inlayHintsShowParameterName = true,
          inlayHintsShowBuiltin = true,
          inlayHintsShowVariableName = true,
          inlayHintsShowFunctionReturnType = true,
          inlayHintsShowType = true,
        },
      },
    },
  },
}
