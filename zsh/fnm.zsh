# Lazy-load fnm - only initialize when node/npm/npx/fnm is first called
# This saves ~36% of shell startup time

if ! command_exists fnm; then
  return 0
fi

# Commands that trigger fnm initialization
_FNM_LAZY_CMDS=(node npm npx yarn pnpm fnm nvm corepack)

_fnm_init() {
  # Remove lazy stubs
  for cmd in $_FNM_LAZY_CMDS; do
    unfunction "$cmd" 2>/dev/null
  done
  unfunction _fnm_init

  # Actually initialize fnm
  eval "$(fnm env)"
  alias nvm="fnm"

  # Set up the autoload hook for .nvmrc
  FNM_USING_LOCAL_VERSION=0

  function _fnm_autoload_hook() {
    local nvmrc_path
    nvmrc_path=$(find_up .nvmrc | tr -d '[:space:]')

    if [[ -n "$nvmrc_path" ]]; then
      FNM_USING_LOCAL_VERSION=1
      fnm use --silent-if-unchanged "$(cat "$nvmrc_path/.nvmrc")"
    elif [[ $FNM_USING_LOCAL_VERSION -eq 1 ]]; then
      FNM_USING_LOCAL_VERSION=0
      fnm use --silent-if-unchanged default
    fi
  }

  add-zsh-hook chpwd _fnm_autoload_hook
  _fnm_autoload_hook
}

# Create lazy stub for each command
for cmd in $_FNM_LAZY_CMDS; do
  eval "function $cmd() { _fnm_init && $cmd \"\$@\" }"
done
unset cmd
