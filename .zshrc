#!/bin/zsh
typeset -F 3 SECONDS=0

function get_dotfiles() {
  # SOURCE="${(%):-%N}"
  SOURCE=${BASH_SOURCE[0]:-${(%):-%x}}
  while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  done
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  echo $DIR
}

export COBBLER_PATH="${HOME}/projects/@cobbler-io/cobbler"

# export PATH=$HOME/bin:/usr/local/bin:$PATH
export GOPATH="${HOME}/go"
PATH="${PATH}:$GOPATH/bin"
PATH="${PATH}:$(get_dotfiles)/bin"
# Add local node_modules
PATH="${PATH}:./node_modules/.bin"

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

ZSH_ALIAS_FINDER_AUTOMATIC=true

# Source zgen first
source "${HOME}/.zgen/zgen.zsh"

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

if ! zgen saved; then
  zgen oh-my-zsh

  zgen oh-my-zsh plugins/alias-finder
  zgen oh-my-zsh plugins/copyfile
  zgen oh-my-zsh plugins/dircycle
  zgen oh-my-zsh plugins/extract
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/git-extras
  zgen oh-my-zsh plugins/npm
  zgen oh-my-zsh plugins/npx
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

  # zgen load iam4x/zsh-iterm-touchbar
  zgen save
fi

setopt AUTO_CD
setopt HIST_REDUCE_BLANKS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST 

autoload -U add-zsh-hook

# Add a fast prompt
eval "$(starship init zsh)"

# Autorun `nvm use` when switching into a directory
# https://github.com/Schniz/fnm/issues/144#issuecomment-674565928

function find-up() {
	path=$(pwd)
	while [[ "$path" != "" && ! -e "$path/$1" ]]; do
		path=${path%/*}
	done
	echo "$path"
}



function _fnm_autoload_hook() {
	nvmrc_path=$(find-up .nvmrc | tr -d '[:space:]')

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
  brew update && brew cask update && brew upgrade && brew cask upgrade && brew doctor && brew clean
}

function update_shell() {
  omz update
  zgen update
}

# eval "$(hub alias -s)" # use the github `hub` wrapper around git

# fnm / an nvm replacement
eval "$(fnm env --multi)"
alias nvm="fnm"; # accommodate muscle memory

eval $(thefuck --alias)

# tabtab source for yarn package uninstall by removing these lines or running `tabtab uninstall yarn`
if [[ -f $HOME/.config/yarn/global/node_modules/tabtab/.completions/yarn.zsh ]]; then
  source $HOME/.config/yarn/global/node_modules/tabtab/.completions/yarn.zsh
fi

alias spj="npx sort-package-json"

alias projects="cd ${HOME}/projects"
alias p="projects"
alias cobbler="cd ${COBBLER_PATH}"
alias cob="cobbler"
alias co="cobbler"
alias dotfiles="cd ${HOME}/projects/dotfiles"
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias github="hub"
alias gco="git checkout"

if [ -n "$PATH" ]; then
  old_PATH=$PATH:; PATH=
  while [ -n "$old_PATH" ]; do
    x=${old_PATH%%:*}       # the first remaining entry
    case $PATH: in
      *:"$x":*) ;;          # already there
      *) PATH=$PATH:$x;;    # not there yet
    esac
    old_PATH=${old_PATH#*:}
  done
  PATH=${PATH#:}
  unset old_PATH x
fi 

export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

# Don't send MS telemetry with dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1

_fnm_autoload_hook

echo "Loaded in ${SECONDS} seconds"
