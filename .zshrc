#!/bin/zsh
typeset -F 3 SECONDS=0

function get_dotfiles() {
  # SOURCE="${(%):-%N}"
  SOURCE=${BASH_SOURCE[0]:-${(%):-%x}}
  while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="${DIR}/${SOURCE}" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  done
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  echo $DIR
}


DOT_PATH="$(get_dotfiles)"

source "${DOT_PATH}/lib/lib.sh" # Helpers needed further down

export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
PATH="${PATH}:${DOT_PATH}/bin" # Add the dotfiles bin to the path

# Load Oh-My-Zsh first
source "${DOT_PATH}/zsh/omz.zsh"

source "${DOT_PATH}/zsh/cmp.zsh" # Add more completion

source "${DOT_PATH}/zsh/aliases.zsh"
source "${DOT_PATH}/zsh/brew.zsh"
source "${DOT_PATH}/zsh/fzf.zsh" # Add fzf config
source "${DOT_PATH}/zsh/git.zsh"
source "${DOT_PATH}/zsh/starship.zsh" # Configure prompt
source "${DOT_PATH}/zsh/utils.zsh"
source "${DOT_PATH}/zsh/wezterm.zsh"


# Add different programming env paths and tool bins
source "${DOT_PATH}/zsh/bun.zsh"
source "${DOT_PATH}/zsh/dotnet.zsh"
source "${DOT_PATH}/zsh/fnm.zsh" # Configure the fast node manager
source "${DOT_PATH}/zsh/go.zsh"
source "${DOT_PATH}/zsh/node.zsh"
source "${DOT_PATH}/zsh/rust.zsh"
source "${DOT_PATH}/zsh/yarn.zsh"


source "${DOT_PATH}/zsh/color_cat.zsh" # Add colors to cat
source "${DOT_PATH}/zsh/color_man_pages.zsh" # Add colors to man page

source "${DOT_PATH}/zsh/nvim.zsh"

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

source_if_exists "${DOT_PATH}/cobbler-commands.zsh"

# Used to profile things
# zmodload zsh/zprof

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/shawn/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "${HOME}/miniconda3/etc/profile.d/conda.sh" ]; then
        source "${HOME}/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="${HOME}/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# De-duplicate PATH elements
source "${DOT_PATH}/lib/dedupe_path.sh"

echo "Loaded in ${SECONDS} seconds"
