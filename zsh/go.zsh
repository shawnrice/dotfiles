if ! command_exists go; then
  echo "[WARN]: go is not installed. Skipping go configuration."
  return 0
fi

export GOPATH="${HOME}/go"
export PATH="${PATH}:$GOPATH/bin"
