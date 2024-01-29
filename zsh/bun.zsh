if ! [ -s "${HOME}/.bun/_bun" ]; then
  echo "[WARN]: bun is not installed. Skipping bun configuration."
  return 0
fi

# bun completions
source "${HOME}/.bun/_bun"

# bun
export BUN_INSTALL="${HOME}/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
