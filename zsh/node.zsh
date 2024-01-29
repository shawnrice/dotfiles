if ! command_exists node; then
  echo "[WARN]: node is not installed. Skipping node configuration."
  return 0
fi

# Add local node_modules
export PATH="${PATH}:./node_modules/.bin"
