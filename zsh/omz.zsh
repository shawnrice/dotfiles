# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"
# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=""

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=6

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

ZSH_ALIAS_FINDER_AUTOMATIC=true

# Source zgen first
source "${HOME}/.zgen/zgen.zsh"

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

export ZSH_WAKATIME_BIN=$(brew --prefix)/bin/wakatime

if ! zgen saved; then
  zgen oh-my-zsh

  zgen oh-my-zsh plugins/alias-finder
  zgen oh-my-zsh plugins/copyfile
  zgen oh-my-zsh plugins/dircycle
  zgen oh-my-zsh plugins/extract
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/git-extras
  zgen oh-my-zsh plugins/npm
  # zgen oh-my-zsh plugins/npx
  zgen oh-my-zsh plugins/thefuck
  zgen oh-my-zsh plugins/vscode
  zgen oh-my-zsh plugins/yarn
  zgen oh-my-zsh plugins/z

  zgen load supercrabtree/k
  zgen load sobolevn/wakatime-zsh-plugin
  zgen load djui/alias-tips
  zgen load peterhurford/git-it-on.zsh
  zgen load unixorn/autoupdate-zgen

  zgen load zsh-users/zsh-completions
  zgen load zsh-users/zsh-autosuggestions
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search
  zgen load zsh-users/zsh-apple-touchbar
  zgen load chrisands/zsh-yarn-completions

  # Theme
  # zgen load denysdovhan/spaceship-prompt spaceship
  zgen save
fi

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
