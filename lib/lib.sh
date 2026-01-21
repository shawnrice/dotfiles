# Shell utility functions

# Detect OS
case "$OSTYPE" in
  darwin*) IS_MACOS=true  IS_LINUX=false ;;
  linux*)  IS_MACOS=false IS_LINUX=true ;;
  *)       IS_MACOS=false IS_LINUX=false ;;
esac

function command_exists() {
  (( $+commands[$1] ))
}

function source_if_exists() {
  [[ -s "$1" ]] && builtin source "$1"
}

function find_up() {
  local path=$(pwd)
  while [[ "$path" != "" && ! -e "$path/$1" ]]; do
    path=${path%/*}
  done
  echo "$path"
}

function trim() {
  local var="${1##*( )}"
  var="${var%%*( )}"
  echo "$var"
}

function external_ip() {
  curl -s "http://myexternalip.com/raw"
}

function reload() {
  exec zsh
}

# Clipboard functions (cross-platform)
function clipcopy() {
  if [[ $OSTYPE == darwin* ]]; then
    pbcopy
  elif [[ -n $WAYLAND_DISPLAY ]]; then
    wl-copy
  elif [[ -n $DISPLAY ]]; then
    xclip -selection clipboard
  fi
}

function clippaste() {
  if [[ $OSTYPE == darwin* ]]; then
    pbpaste
  elif [[ -n $WAYLAND_DISPLAY ]]; then
    wl-paste
  elif [[ -n $DISPLAY ]]; then
    xclip -selection clipboard -o
  fi
}

# Copy path of given directory or file to clipboard (default: current dir)
function copypath() {
  local file="${1:-.}"
  [[ $file = /* ]] || file="$PWD/$file"
  print -n "${file:a}" | clipcopy || return 1
  echo ${(%):-"%B${file:a}%b copied to clipboard."}
}

# Copy file contents to clipboard
function copyfile() {
  emulate -L zsh
  clipcopy < "$1"
}

# Colored man pages
function man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}
