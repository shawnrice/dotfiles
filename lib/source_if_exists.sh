function source_if_exists() {
  [[ -s "$1" ]] && source "$1"
}
