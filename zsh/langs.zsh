# Language environment configuration

# Bun
if [[ -d "${HOME}/.bun" ]]; then
  export BUN_INSTALL="${HOME}/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  [[ -s "${BUN_INSTALL}/_bun" ]] && source "${BUN_INSTALL}/_bun"
fi

# .NET
if command_exists dotnet; then
  export DOTNET_CLI_TELEMETRY_OPTOUT=1
  export PATH="${PATH}:${HOME}/.dotnet/tools"
fi

# Go
if command_exists go; then
  export GOPATH="${HOME}/go"
  export PATH="${PATH}:$GOPATH/bin"
fi

# Rust
source_if_exists "${HOME}/.cargo/env"
export PATH="$PATH:${HOME}/.cargo/bin"

# Yarn (may be managed by fnm/corepack)
[[ -d "$HOME/.yarn/bin" ]] && export PATH="$HOME/.yarn/bin:$PATH"
[[ -d "$HOME/.config/yarn/global/node_modules/.bin" ]] && export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
