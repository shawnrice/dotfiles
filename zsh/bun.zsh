# bun - only configure if installed
if [[ -d "${HOME}/.bun" ]]; then
  export BUN_INSTALL="${HOME}/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  [[ -s "${BUN_INSTALL}/_bun" ]] && source "${BUN_INSTALL}/_bun"
fi
