if ! command_exists yarn; then
  echo "[WARN]: yarn is not installed. Skipping yarn configuration."
  return 0
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
