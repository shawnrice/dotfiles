if ! command_exists brew; then
  echo "[WARN]: brew is not installed. Skipping brew configuration."
  return 0
fi

function brewup() {
  brew update && brew upgrade && brew upgrade --cask && brew doctor && brew clean
}
