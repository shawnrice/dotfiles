if ! command_exists fnm; then
  echo "[WARN]: fnm is not installed. Skipping fnm configuration."
  return 0
fi

function _fnm_autoload_hook() {
  nvmrc_path=$(find_up .nvmrc | tr -d '[:space:]')

  if [ -n "$nvmrc_path" ]; then
    FNM_USING_LOCAL_VERSION=1
    nvm_version=$(cat $nvmrc_path/.nvmrc)
    fnm use $nvm_version
  elif [ $FNM_USING_LOCAL_VERSION -eq 1 ]; then
    FNM_USING_LOCAL_VERSION=0
    fnm use default
  fi
}

FNM_USING_LOCAL_VERSION=0

add-zsh-hook chpwd _fnm_autoload_hook

# fnm / an nvm replacement
eval "$(fnm env)"
alias nvm="fnm" # accommodate muscle memory

_fnm_autoload_hook
