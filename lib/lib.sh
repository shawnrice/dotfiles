# Shell utility functions

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
