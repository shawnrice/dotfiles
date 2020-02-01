function get_dotfiles() {
  SOURCE="${BASH_SOURCE[0]}"
  while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  done
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  echo $DIR
}

# export PATH=$HOME/bin:/usr/local/bin:$PATH
export GOPATH="${HOME}/go"
PATH="${PATH}:$GOPATH/bin"
PATH="${PATH}:$(get_dotfiles)/bin"

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"
# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

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

# Source zgen first
source "${HOME}/.zgen/zgen.zsh"

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

if ! zgen saved; then
  zgen oh-my-zsh

  zgen oh-my-zsh plugins/copyfile
  zgen oh-my-zsh plugins/dircycle
  zgen oh-my-zsh plugins/extract
  zgen oh-my-zsh plugins/git
  # zgen oh-my-zsh plugins/git-extras
  zgen oh-my-zsh plugins/npm
  zgen oh-my-zsh plugins/npx
  zgen oh-my-zsh plugins/thefuck
  zgen oh-my-zsh plugins/vscode
  zgen oh-my-zsh plugins/yarn
  zgen oh-my-zsh plugins/z

  zgen load supercrabtree/k
  zgen load sobolevn/wakatime-zsh-plugin

  zgen load zsh-users/zsh-autosuggestions
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search
  zgen load zsh-users/zsh-apple-touchbar

  # Theme
  # zgen load denysdovhan/spaceship-prompt spaceship

  # zgen load iam4x/zsh-iterm-touchbar
  zgen save
fi

# Add a fast prompt
eval "$(starship init zsh)"

# Integrate with iterm2
source "${HOME}/.iterm2_shell_integration.zsh"
function iterm2_print_user_vars() {
  iterm2_set_user_var gitBranch $((git branch 2> /dev/null) | grep \* | cut -c3-)
}

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'


# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}


function reload() {
	source "${HOME}/.zshrc"
}

function brewup() {
  brew update && brew upgrade && brew doctor && brew clean
}

eval "$(hub alias -s)" # use the github `hub` wrapper around git

# fnm / an nvm replacement
eval "$(fnm env --multi)"
alias nvm="fnm"; # accommodate muscle memory

eval $(thefuck --alias)

# tabtab source for yarn package uninstall by removing these lines or running `tabtab uninstall yarn`
if [[ -f $HOME/.config/yarn/global/node_modules/tabtab/.completions/yarn.zsh ]]; then
  source $HOME/.config/yarn/global/node_modules/tabtab/.completions/yarn.zsh
fi

alias spj="npx sort-package-json"

alias cobbler="cd ${HOME}/projects/cobbler"
alias cob="cobbler"
alias co="cobbler"
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"

