zmodload zsh/zprof

typeset -F 3 SECONDS=0


# Make the terminal not beep
setopt no_beep

function get_dots() {
  # SOURCE="${(%):-%N}"
  SOURCE=${BASH_SOURCE[0]:-${(%):-%x}}
  # resolve $SOURCE until the file is no longer a symlink
  while [ -h "$SOURCE" ]; do 
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    [[ $SOURCE != /* ]] && SOURCE="${DIR}/${SOURCE}" 
  done
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  echo $DIR
}

export EDITOR='nvim'

# fuzzy grep open via ag with line number
ng() {
  local file
  local line

  read -r file line <<<"$(ag --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"

  if [[ -n $file ]]
  then
     nvim $file +$line
  fi
}

# Determines which package manager is used at cwd
__which_node_pm() {
  if [[ -f yarn.lock ]]; then
    echo "yarn"
  elif [[ -f pnpm-lock.yaml ]]; then
    echo "pnpm"
  elif [[ -f bun.lock ]]; then
    echo "bun"
  elif [[ -f package-lock.json ]]; then
    echo "npm"
  else
    echo "npm"
  fi
}

# run node script (requires jq)
# Run npm/yarn/pnpm/bun script with frecency sorting (requires jq and fzf)
fns() {
  local script pm history_file
  history_file="$HOME/.cache/fns_history"

  # Create cache directory if it doesn't exist
  mkdir -p "$(dirname "$history_file")"

  # Create or update the frecency history file
  if [[ ! -f $history_file ]]; then
    touch "$history_file"
  fi

  # Determine the package manager
  pm=$(__which_node_pm)

  # Extract scripts and sort by frecency
  script=$(cat package.json | jq -r '.scripts | keys[]' | awk -v hist="$history_file" '
    BEGIN { while ((getline < hist) > 0) count[$1] += $2 }
    { print $0, count[$0] + 0 }
  ' | sort -k2,2nr -k1,1 | cut -d' ' -f1 | fzf) || return

  # Update frecency history
  if [[ -n $script ]]; then
    awk -v script="$script" '
      $1 == script { $2++; found = 1; print; next }
      { print }
      END { if (!found) print script, 1 }
    ' "$history_file" > "${history_file}.tmp" && mv "${history_file}.tmp" "$history_file"

    # Run the selected script
    $pm run "$script"
  fi
}

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

DOTS="$(get_dots)"
unset get_dots

# Load the zim framework
builtin source "${DOTS}/zsh/zim.zsh"

# Sets approprate environment variables for the OS
builtin source "${DOTS}/lib/detect_os.sh" # Detect the OS

# Add a couple of things to the path
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/usr/local/sbin"
PATH="${PATH}:${DOTS}/bin" # Add the dotfiles bin to the path

builtin source "${DOTS}/lib/lib.sh" # Helpers needed further down

# Homebrew prefix - hardcoded for speed (brew --prefix is slow)
# Apple Silicon: /opt/homebrew, Intel: /usr/local
if [[ -d /opt/homebrew ]]; then
  BREW_PREFIX=/opt/homebrew
elif [[ -d /usr/local/Homebrew ]]; then
  BREW_PREFIX=/usr/local
fi

# Load Oh-My-Zsh first
# builtin source "${DOTS}/zsh/omz.zsh"

builtin source "${DOTS}/zsh/cmp.zsh" # Add more completion

builtin source "${DOTS}/zsh/aliases.zsh"
builtin source "${DOTS}/zsh/brew.zsh"
builtin source "${DOTS}/zsh/fzf.zsh" # Add fzf config
builtin source "${DOTS}/zsh/git.zsh"
builtin source "${DOTS}/zsh/starship.zsh" # Configure prompt
builtin source "${DOTS}/zsh/utils.zsh"
builtin source "${DOTS}/zsh/wezterm.zsh"


# Add different programming env paths and tool bins
builtin source "${DOTS}/zsh/bun.zsh"
builtin source "${DOTS}/zsh/dotnet.zsh"
builtin source "${DOTS}/zsh/fnm.zsh" # Configure the fast node manager
builtin source "${DOTS}/zsh/go.zsh"
builtin source "${DOTS}/zsh/node.zsh"
builtin source "${DOTS}/zsh/rust.zsh"
builtin source "${DOTS}/zsh/yarn.zsh"


builtin source "${DOTS}/zsh/color_cat.zsh" # Add colors to cat
builtin source "${DOTS}/zsh/color_man_pages.zsh" # Add colors to man page

builtin source "${DOTS}/zsh/nvim.zsh"

# eval $(thefuck --alias)

# Cached zoxide init (regenerates if binary changes)
_zoxide_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zoxide_init.zsh"
if command_exists zoxide; then
  _zoxide_bin="$(command -v zoxide)"
  if [[ ! -f "$_zoxide_cache" || "$_zoxide_bin" -nt "$_zoxide_cache" ]]; then
    zoxide init zsh > "$_zoxide_cache"
  fi
  source "$_zoxide_cache"
  unset _zoxide_bin
fi
unset _zoxide_cache

# LISTMAX=0
# unsetopt LIST_AMBIGUOUS MENU_COMPLETE COMPLETE_IN_WORD
# setopt AUTO_MENU AUTO_LIST LIST_PACKED
# unambigandmenu() {
#   echo -n "\e[31m...\e[0m"
#   # avoid opening the list on the first expand
#   unsetopt AUTO_LIST
#   zle expand-or-complete
#   setopt AUTO_LIST
#   zle magic-space
#   zle backward-delete-char
#   zle expand-or-complete
#   zle redisplay
# }
# zle -N unambigandmenu
# bindkey "^i" unambigandmenu


# Configure colors for the 'ls' command output. This makes different types of files and directories 
# appear in different colors, improving readability and file type distinction. The format is 'TYPE=COLOR':
#   di=34   : Directories are blue.
#   ln=35   : Symbolic links are magenta.
#   so=32   : Sockets are green.
#   pi=33   : Named pipes (FIFO) are yellow.
#   ex=31   : Executable files are red.
#   bd=34;46: Block devices (e.g., disk partitions) are blue with a cyan background.
#   cd=34;43: Character devices are blue with a yellow background.
#   su=30;41: Files with setuid are black with a red background.
#   sg=30;46: Files with setgid are black with a cyan background.
#   tw=30;42: Directories writable to others, with sticky bit, are black with a green background.
#   ow=30;43: Directories writable to others, without sticky bit, are black with a yellow background.
# The color codes (like 34, 35, etc.) are ANSI color codes. 'di', 'ln', etc., are file type indicators.
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"
export LC_ALL=

# Untracked things for the work computer
source_if_exists "${DOTS}/zsh/work/aliases.zsh"
source_if_exists "${DOTS}/zsh/work/commands.zsh"

# Used to profile things
# zmodload zsh/zprof

# De-duplicate PATH elements
source "${DOTS}/lib/dedupe_path.sh"

echo "Loaded in ${SECONDS} seconds"
unset SECONDS

# Machine-specific config (not in git)
source_if_exists ~/.zshrc.local

# === AUTO-ADDED (move to .zshrc.local) ===
