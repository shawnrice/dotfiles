function command_exists() {
  [[ ! -z "$(command -v $1)" ]]
}
