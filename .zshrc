#!/usr/bin/env zsh

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

DOTS="$(get_dots)"
unset get_dots

source "${DOTS}/lib/detect_os.sh" # Detect the OS

$IS_MACOS && echo "MacOS"
$IS_LINUX && echo "Linux"
$IS_WSL && echo "WSL"

# Add a couple of things to the path
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
PATH="${PATH}:${DOTS}/bin" # Add the dotfiles bin to the path

source "${DOTS}/lib/lib.sh" # Helpers needed further down

# Load Oh-My-Zsh first
source "${DOTS}/zsh/omz.zsh"

source "${DOTS}/zsh/cmp.zsh" # Add more completion

source "${DOTS}/zsh/aliases.zsh"
source "${DOTS}/zsh/brew.zsh"
source "${DOTS}/zsh/fzf.zsh" # Add fzf config
source "${DOTS}/zsh/git.zsh"
source "${DOTS}/zsh/starship.zsh" # Configure prompt
source "${DOTS}/zsh/utils.zsh"
source "${DOTS}/zsh/wezterm.zsh"


# Add different programming env paths and tool bins
source "${DOTS}/zsh/bun.zsh"
source "${DOTS}/zsh/dotnet.zsh"
source "${DOTS}/zsh/fnm.zsh" # Configure the fast node manager
source "${DOTS}/zsh/go.zsh"
source "${DOTS}/zsh/node.zsh"
source "${DOTS}/zsh/rust.zsh"
source "${DOTS}/zsh/yarn.zsh"


source "${DOTS}/zsh/color_cat.zsh" # Add colors to cat
source "${DOTS}/zsh/color_man_pages.zsh" # Add colors to man page

source "${DOTS}/zsh/nvim.zsh"

eval $(thefuck --alias)

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

# Untracked things for the work computer
source_if_exists "${DOTS}/zsh/work/aliases.zsh"
source_if_exists "${DOTS}/zsh/work/commands.zsh"

# Used to profile things
# zmodload zsh/zprof

# De-duplicate PATH elements
source "${DOTS}/lib/dedupe_path.sh"

echo "Loaded in ${SECONDS} seconds"
unset SECONDS
