function source_if_exists() {
  [[ -s "$1" ]] && source "$1"
}

function command_exists() {
  [[ ! -z "$(command -v $1)" ]]
}
