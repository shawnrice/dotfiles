ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"

if [ ! -d $ZINIT_HOME/.git ]; then
  echo "Installing zinit"
  git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

builtin source "${ZINIT_HOME}/zinit.zsh"

function update_shell() {
  # Update Zinit itself
  zinit self-update

  # Update Zinit plugins
  zinit update --parallel
}

function maybe_update_zinit() {
  local update_file="$HOME/.last_zinit_update"
  local current_time=$(date +%s)
  local last_update=0
  local update_interval=$((24 * 60 * 60)) # daily

  [[ -f "$update_file" ]] && read last_update <"$update_file"

  if ((current_time - last_update > update_interval)); then
    update_shell
    echo "$current_time" >"$update_file"
  fi
}

maybe_update_zinit
unset maybe_update_zinit

if type brew &>/dev/null; then
  FPATH=$BREW_PREFIX/share/zsh/site-functions:$FPATH
  export ZSH_WAKATIME_BIN=$BREW_PREFIX/bin/wakatime
fi

# zinit oh-my-zsh plugins/thefuck
# zinit oh-my-zsh plugins/z

# zinit load supercrabtree/k
zinit light sobolevn/wakatime-zsh-plugin

# Look here, update and prune
# https://github.com/peterhurford/git-it-on.zsh/blob/master/git-it-on.plugin.zsh

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
# zinit light zsh-users/zsh-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-history-substring-search

zinit light chrisands/zsh-yarn-completions

setopt AUTO_CD
setopt HIST_REDUCE_BLANKS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST

autoload -U add-zsh-hook

function update_shell() {
  omz update
  zgen update
}
