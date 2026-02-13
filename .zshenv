# .zshenv - sourced for ALL zsh shells (interactive + non-interactive)
# Keep this minimal - heavy stuff goes in .zshrc

# uv (Python package manager)
export PATH="$HOME/.local/bin:$PATH"

# Homebrew — needed before fnm check on non-nix machines
if [[ -d /opt/homebrew ]]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi

# fnm — add default node version to PATH
# This ensures node/npm/yarn/etc. are available as real binaries in all contexts
# (non-interactive shells, zellij panes, IDE tasks, direct exec).
# Interactive shells get full per-project switching via fnm.zsh in .zshrc.
_fnm_default="$HOME/Library/Application Support/fnm/aliases/default/bin"
if [[ -d "$_fnm_default" ]]; then
  export PATH="$_fnm_default:$PATH"
fi
unset _fnm_default
