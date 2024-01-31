function source_if_exists() {
  [[ -s "$1" ]] && builtin source "$1"
}
