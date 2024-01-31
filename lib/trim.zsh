function trim() {
  # Remove leading whitespace
  local var="${1##*( )}"

  # Remove trailing whitespace
  var="${var%%*( )}"

  echo "$var"
}
