# Homebrew completions (BREW_PREFIX set in .zshrc)
if [[ -n "$BREW_PREFIX" ]]; then
  FPATH="${BREW_PREFIX}/share/zsh/site-functions:${FPATH}"
fi

autoload -Uz compinit
