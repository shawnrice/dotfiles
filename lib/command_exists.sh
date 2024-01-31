function command_exists() {
  (( $+commands[$1] ))
}
